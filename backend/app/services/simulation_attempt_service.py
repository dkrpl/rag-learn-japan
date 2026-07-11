from collections import Counter
from datetime import datetime, timedelta, timezone

from fastapi import HTTPException, status
from sqlalchemy.orm import Session, selectinload

from app.models.question import Question
from app.models.simulation import (
    JlptSimulation,
    UserSimulationAttempt,
    UserSimulationAttemptQuestion,
    UserSimulationAttemptSection,
)
from app.services.scoring import ScoringError, evaluate_answer


class SimulationAttemptService:
    terminal_statuses = {"COMPLETED", "EXPIRED", "CANCELLED"}

    @staticmethod
    def _attempt_query(db: Session, attempt_id: str, user_id: str):
        return (
            db.query(UserSimulationAttempt)
            .options(
                selectinload(UserSimulationAttempt.simulation),
                selectinload(UserSimulationAttempt.attempt_sections).selectinload(UserSimulationAttemptSection.section),
                selectinload(UserSimulationAttempt.attempt_sections)
                .selectinload(UserSimulationAttemptSection.attempt_questions)
                .selectinload(UserSimulationAttemptQuestion.question_revision),
            )
            .filter(UserSimulationAttempt.id == attempt_id, UserSimulationAttempt.user_id == user_id)
        )

    @staticmethod
    def create_attempt(db: Session, user_id: str, simulation_id: str):
        simulation = (
            db.query(JlptSimulation)
            .filter(
                JlptSimulation.id == simulation_id,
                JlptSimulation.is_published.is_(True),
                JlptSimulation.is_archived.is_(False),
            )
            .first()
        )
        if not simulation:
            raise HTTPException(status_code=404, detail="Simulation not found or not published")
        if not simulation.sections or any(not section.questions for section in simulation.sections):
            raise HTTPException(status_code=409, detail="Simulation configuration is incomplete")

        active = (
            db.query(UserSimulationAttempt)
            .filter(
                UserSimulationAttempt.user_id == user_id,
                UserSimulationAttempt.simulation_id == simulation_id,
                UserSimulationAttempt.status.in_(["STARTED", "IN_PROGRESS"]),
            )
            .first()
        )
        if active:
            raise HTTPException(status_code=409, detail="An active attempt already exists")

        try:
            attempt = UserSimulationAttempt(user_id=user_id, simulation_id=simulation.id, status="STARTED")
            db.add(attempt)
            db.flush()
            total_questions = 0
            for simulation_section in simulation.sections:
                attempt_section = UserSimulationAttemptSection(
                    attempt_id=attempt.id,
                    section_id=simulation_section.id,
                    status="NOT_STARTED",
                    question_count=len(simulation_section.questions),
                )
                db.add(attempt_section)
                db.flush()
                for mapping in simulation_section.questions:
                    question = db.query(Question).filter(Question.id == mapping.question_id).first()
                    latest_revision = question.revisions[-1] if question and question.revisions else None
                    if not question or not latest_revision:
                        raise HTTPException(
                            status_code=409,
                            detail=f"Question {mapping.question_id} has no immutable revision",
                        )
                    db.add(
                        UserSimulationAttemptQuestion(
                            attempt_id=attempt.id,
                            attempt_section_id=attempt_section.id,
                            question_id=question.id,
                            question_revision_id=latest_revision.id,
                            order_number=mapping.order_number,
                        )
                    )
                    total_questions += 1
            attempt.question_count = total_questions
            db.commit()
        except Exception:
            db.rollback()
            raise
        return SimulationAttemptService.get_attempt(db, attempt.id, user_id)

    @staticmethod
    def get_attempt(db: Session, attempt_id: str, user_id: str):
        attempt = SimulationAttemptService._attempt_query(db, attempt_id, user_id).first()
        if not attempt:
            raise HTTPException(status_code=404, detail="Attempt not found")
        active = next((section for section in attempt.attempt_sections if section.status == "IN_PROGRESS"), None)
        if active:
            SimulationAttemptService._enforce_timer(db, active)
            db.refresh(attempt)
        return SimulationAttemptService._format_attempt_response(attempt)

    @staticmethod
    def list_attempts(db: Session, user_id: str, offset: int = 0, limit: int = 20):
        attempts = (
            db.query(UserSimulationAttempt)
            .options(selectinload(UserSimulationAttempt.simulation))
            .filter(UserSimulationAttempt.user_id == user_id)
            .order_by(UserSimulationAttempt.created_at.desc())
            .offset(offset)
            .limit(limit)
            .all()
        )
        return [
            {
                "id": attempt.id,
                "simulation_id": attempt.simulation_id,
                "simulation_title": attempt.simulation.title,
                "status": attempt.status,
                "started_at": attempt.started_at,
                "completed_at": attempt.completed_at,
                "total_score": attempt.total_score,
                "is_passed": attempt.is_passed,
            }
            for attempt in attempts
        ]

    @staticmethod
    def start_next_section(db: Session, attempt_id: str, user_id: str):
        attempt = SimulationAttemptService._attempt_query(db, attempt_id, user_id).with_for_update().first()
        if not attempt:
            raise HTTPException(status_code=404, detail="Attempt not found")
        if attempt.status in SimulationAttemptService.terminal_statuses:
            raise HTTPException(status_code=409, detail=f"Attempt is {attempt.status.lower()}")

        ordered_sections = sorted(attempt.attempt_sections, key=lambda item: item.section.sequence)
        active = next((section for section in ordered_sections if section.status == "IN_PROGRESS"), None)
        if active:
            SimulationAttemptService._enforce_timer(db, active)
            if active.status == "IN_PROGRESS":
                raise HTTPException(status_code=409, detail="Complete the active section first")

        next_section = next((section for section in ordered_sections if section.status == "NOT_STARTED"), None)
        if not next_section:
            raise HTTPException(status_code=409, detail="No section remains to be started")
        next_section.status = "IN_PROGRESS"
        next_section.started_at = datetime.now(timezone.utc)
        attempt.status = "IN_PROGRESS"
        db.commit()
        return SimulationAttemptService.get_attempt(db, attempt.id, user_id)

    @staticmethod
    def submit_answer(
        db: Session,
        attempt_id: str,
        user_id: str,
        question_id: str,
        answer_data: dict,
        response_time_ms: int | None = None,
    ) -> None:
        attempt = SimulationAttemptService._attempt_query(db, attempt_id, user_id).with_for_update().first()
        if not attempt:
            raise HTTPException(status_code=404, detail="Attempt not found")
        if attempt.status != "IN_PROGRESS":
            raise HTTPException(status_code=409, detail="Attempt is not in progress")
        active = next((section for section in attempt.attempt_sections if section.status == "IN_PROGRESS"), None)
        if not active:
            raise HTTPException(status_code=409, detail="No active section")
        SimulationAttemptService._enforce_timer(db, active)
        if active.status == "EXPIRED":
            raise HTTPException(status_code=409, detail="Section time has expired")

        attempt_question = next(
            (item for item in active.attempt_questions if item.question_id == question_id),
            None,
        )
        if not attempt_question:
            raise HTTPException(status_code=404, detail="Question is not in the active section")
        try:
            # Validate shape now; correctness remains hidden until completion.
            evaluate_answer(
                attempt_question.question_revision.question_type,
                attempt_question.question_revision.answer_key_json,
                answer_data,
            )
        except ScoringError as exc:
            raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=str(exc)) from exc

        attempt_question.answer_data_json = answer_data
        attempt_question.response_time_ms = response_time_ms
        attempt_question.is_answered = True
        db.commit()

    @staticmethod
    def complete_current_section(db: Session, attempt_id: str, user_id: str):
        attempt = SimulationAttemptService._attempt_query(db, attempt_id, user_id).with_for_update().first()
        if not attempt:
            raise HTTPException(status_code=404, detail="Attempt not found")
        active = next((section for section in attempt.attempt_sections if section.status == "IN_PROGRESS"), None)
        if not active:
            raise HTTPException(status_code=409, detail="No active section")
        SimulationAttemptService._enforce_timer(db, active)
        if active.status == "IN_PROGRESS":
            active.status = "COMPLETED"
            active.completed_at = datetime.now(timezone.utc)
        db.commit()
        return SimulationAttemptService.get_attempt(db, attempt.id, user_id)

    @staticmethod
    def cancel_attempt(db: Session, attempt_id: str, user_id: str):
        attempt = SimulationAttemptService._attempt_query(db, attempt_id, user_id).with_for_update().first()
        if not attempt:
            raise HTTPException(status_code=404, detail="Attempt not found")
        if attempt.status == "COMPLETED":
            raise HTTPException(status_code=409, detail="Completed attempt cannot be cancelled")
        if attempt.status != "CANCELLED":
            attempt.status = "CANCELLED"
            attempt.cancelled_at = datetime.now(timezone.utc)
            db.commit()
        return SimulationAttemptService.get_attempt(db, attempt.id, user_id)

    @staticmethod
    def complete_simulation(db: Session, attempt_id: str, user_id: str):
        attempt = SimulationAttemptService._attempt_query(db, attempt_id, user_id).with_for_update().first()
        if not attempt:
            raise HTTPException(status_code=404, detail="Attempt not found")
        if attempt.status == "COMPLETED":
            return SimulationAttemptService.get_result(db, attempt_id, user_id)
        if attempt.status in {"CANCELLED", "EXPIRED"}:
            raise HTTPException(status_code=409, detail=f"Attempt is {attempt.status.lower()}")

        now = datetime.now(timezone.utc)
        for section in attempt.attempt_sections:
            if section.status == "IN_PROGRESS":
                SimulationAttemptService._enforce_timer(db, section)
                if section.status == "IN_PROGRESS":
                    section.status = "COMPLETED"
                    section.completed_at = now
            elif section.status == "NOT_STARTED":
                section.status = "COMPLETED"
                section.completed_at = now
        attempt.status = "COMPLETED"
        attempt.completed_at = now
        SimulationAttemptService._calculate_scores(attempt)
        db.commit()
        return SimulationAttemptService.get_result(db, attempt_id, user_id)

    @staticmethod
    def get_result(db: Session, attempt_id: str, user_id: str):
        attempt = SimulationAttemptService._attempt_query(db, attempt_id, user_id).first()
        if not attempt:
            raise HTTPException(status_code=404, detail="Attempt not found")
        if attempt.status != "COMPLETED":
            raise HTTPException(status_code=409, detail="Results are available only after completion")

        section_scores = [
            {
                "section_title": section.section.title,
                "score": section.score,
                "correct_count": section.correct_count,
                "question_count": section.question_count,
                "is_passed": section.is_passed,
                "passing_score": section.section.passing_score,
            }
            for section in sorted(attempt.attempt_sections, key=lambda item: item.section.sequence)
        ]
        incorrect_by_skill: Counter[str] = Counter()
        for question in attempt.attempt_questions:
            if not question.is_correct:
                incorrect_by_skill[question.question_revision.skill.value] += 1
        weaknesses = [
            {
                "skill": skill,
                "incorrect_count": count,
                "recommendation": f"Prioritaskan review dan latihan {skill.lower()}.",
            }
            for skill, count in incorrect_by_skill.most_common()
        ]
        return {
            "attempt_id": attempt.id,
            "simulation_title": attempt.simulation.title,
            "total_score": attempt.total_score,
            "passing_score": attempt.simulation.passing_score,
            "correct_count": attempt.correct_count,
            "question_count": attempt.question_count,
            "is_passed": attempt.is_passed,
            "completed_at": attempt.completed_at,
            "section_scores": section_scores,
            "weaknesses": weaknesses,
        }

    @staticmethod
    def _enforce_timer(db: Session, section: UserSimulationAttemptSection) -> None:
        if section.status != "IN_PROGRESS" or not section.started_at:
            return
        started_at = section.started_at
        if started_at.tzinfo is None:
            started_at = started_at.replace(tzinfo=timezone.utc)
        deadline = started_at + timedelta(minutes=section.section.duration_minutes, seconds=30)
        if datetime.now(timezone.utc) > deadline:
            section.status = "EXPIRED"
            section.completed_at = datetime.now(timezone.utc)
            db.commit()

    @staticmethod
    def _format_attempt_response(attempt: UserSimulationAttempt):
        active = next((section for section in attempt.attempt_sections if section.status == "IN_PROGRESS"), None)
        current_section = None
        if active:
            current_section = {
                "id": active.id,
                "section_id": active.section_id,
                "status": active.status,
                "started_at": active.started_at,
                "completed_at": active.completed_at,
                "title": active.section.title,
                "duration_minutes": active.section.duration_minutes,
                "questions": [
                    {
                        "id": question.id,
                        "question_id": question.question_id,
                        "order_number": question.order_number,
                        "is_answered": question.is_answered,
                        "prompt_json": question.question_revision.prompt_json,
                    }
                    for question in sorted(active.attempt_questions, key=lambda item: item.order_number)
                ],
            }
        return {
            "id": attempt.id,
            "simulation_id": attempt.simulation_id,
            "status": attempt.status,
            "started_at": attempt.started_at,
            "completed_at": attempt.completed_at,
            "total_score": attempt.total_score,
            "is_passed": attempt.is_passed,
            "simulation_title": attempt.simulation.title,
            "current_section": current_section,
        }

    @staticmethod
    def _calculate_scores(attempt: UserSimulationAttempt) -> None:
        total_score = 0
        total_correct = 0
        all_sections_passed = True
        for section in attempt.attempt_sections:
            correct_count = 0
            for question in section.attempt_questions:
                if not question.is_answered or not question.answer_data_json:
                    question.is_correct = False
                    question.score = 0
                    continue
                is_correct, score, _ = evaluate_answer(
                    question.question_revision.question_type,
                    question.question_revision.answer_key_json,
                    question.answer_data_json,
                )
                question.is_correct = is_correct
                question.score = score
                correct_count += int(is_correct)

            question_count = len(section.attempt_questions)
            section.question_count = question_count
            section.correct_count = correct_count
            # JLPT sections are represented on a 60 point scale.
            section.score = round((correct_count / question_count) * 60) if question_count else 0
            section.is_passed = section.score >= section.section.passing_score
            all_sections_passed = all_sections_passed and section.is_passed
            total_score += section.score
            total_correct += correct_count

        attempt.total_score = total_score
        attempt.correct_count = total_correct
        attempt.question_count = len(attempt.attempt_questions)
        attempt.is_passed = all_sections_passed and total_score >= attempt.simulation.passing_score
