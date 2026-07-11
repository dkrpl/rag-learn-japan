import json
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import case, func
from sqlalchemy.orm import Session, selectinload

from app.api.deps import RoleChecker
from app.db.session import get_db
from app.models.ai_jobs import AuditLog
from app.models.question import Question, QuestionStatus
from app.models.simulation import (
    JlptSimulation,
    JlptSimulationQuestion,
    JlptSimulationSection,
    UserSimulationAttempt,
)
from app.models.user import User, UserRole
from app.schemas.simulation import (
    JlptSimulationCreate,
    JlptSimulationListResponse,
    JlptSimulationResponse,
    JlptSimulationSectionCreate,
    JlptSimulationUpdate,
    SimulationAnalyticsResponse,
)

router = APIRouter()
editor_only = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
publisher_only = RoleChecker([UserRole.REVIEWER, UserRole.ADMINISTRATOR])


def _query_simulation(db: Session, simulation_id: str, *, lock: bool = False):
    query = (
        db.query(JlptSimulation)
        .options(selectinload(JlptSimulation.sections).selectinload(JlptSimulationSection.questions))
        .filter(JlptSimulation.id == simulation_id)
    )
    if lock:
        query = query.with_for_update()
    simulation = query.first()
    if simulation is None:
        raise HTTPException(status_code=404, detail="Simulation not found")
    return simulation


def _list_item(simulation: JlptSimulation) -> dict:
    return {
        "id": simulation.id,
        "title": simulation.title,
        "description": simulation.description,
        "level": simulation.level,
        "passing_score": simulation.passing_score,
        "is_published": simulation.is_published,
        "is_archived": simulation.is_archived,
        "section_count": len(simulation.sections),
        "total_duration_minutes": sum(section.duration_minutes for section in simulation.sections),
        "created_at": simulation.created_at,
        "updated_at": simulation.updated_at,
    }


def _audit(
    db: Session,
    *,
    actor_id: str,
    action: str,
    simulation_id: str,
    details: dict | None = None,
) -> None:
    db.add(
        AuditLog(
            user_id=actor_id,
            action=action,
            entity_name="JlptSimulation",
            entity_id=simulation_id,
            details=json.dumps(details or {}, separators=(",", ":"), sort_keys=True),
        )
    )


def _replace_sections(
    db: Session,
    simulation: JlptSimulation,
    section_inputs: list[JlptSimulationSectionCreate],
) -> None:
    question_ids = [item.question_id for section_input in section_inputs for item in section_input.questions]
    if len(question_ids) != len(set(question_ids)):
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="A question may only appear once in a simulation",
        )

    questions = (
        db.query(Question).options(selectinload(Question.revisions)).filter(Question.id.in_(question_ids)).all()
        if question_ids
        else []
    )
    question_by_id = {question.id: question for question in questions}
    invalid_ids = [
        question_id
        for question_id in question_ids
        if question_id not in question_by_id
        or question_by_id[question_id].status != QuestionStatus.PUBLISHED
        or not question_by_id[question_id].revisions
    ]
    if invalid_ids:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={
                "message": "Every simulation question must be published and have a revision",
                "question_ids": sorted(set(invalid_ids)),
            },
        )

    simulation.sections.clear()
    for section_input in sorted(section_inputs, key=lambda item: item.sequence):
        order_numbers = [item.order_number for item in section_input.questions]
        if len(order_numbers) != len(set(order_numbers)):
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail=f"Question order must be unique in section {section_input.sequence}",
            )
        section = JlptSimulationSection(
            title=section_input.title,
            section_type=section_input.section_type,
            sequence=section_input.sequence,
            duration_minutes=section_input.duration_minutes,
            passing_score=section_input.passing_score,
        )
        section.questions = [
            JlptSimulationQuestion(
                question_id=question_input.question_id,
                order_number=question_input.order_number,
            )
            for question_input in sorted(
                section_input.questions,
                key=lambda item: item.order_number,
            )
        ]
        simulation.sections.append(section)


def _ensure_publishable(simulation: JlptSimulation) -> None:
    if simulation.is_archived:
        raise HTTPException(status_code=409, detail="Archived simulations cannot be published")
    if not simulation.sections:
        raise HTTPException(status_code=409, detail="Simulation must contain at least one section")
    if any(not section.questions for section in simulation.sections):
        raise HTTPException(status_code=409, detail="Every section must contain a question")


@router.get("", response_model=list[JlptSimulationListResponse])
def list_simulations(
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=50, ge=1, le=200),
    include_archived: bool = False,
    db: Session = Depends(get_db),
    _: User = Depends(editor_only),
):
    query = db.query(JlptSimulation).options(selectinload(JlptSimulation.sections))
    if not include_archived:
        query = query.filter(JlptSimulation.is_archived.is_(False))
    simulations = query.order_by(JlptSimulation.created_at.desc()).offset(offset).limit(limit).all()
    return [_list_item(simulation) for simulation in simulations]


@router.post("", response_model=JlptSimulationResponse, status_code=status.HTTP_201_CREATED)
def create_simulation(
    payload: JlptSimulationCreate,
    db: Session = Depends(get_db),
    actor: User = Depends(editor_only),
):
    simulation = JlptSimulation(
        title=payload.title,
        description=payload.description,
        level=payload.level,
        passing_score=payload.passing_score,
    )
    db.add(simulation)
    _replace_sections(db, simulation, payload.sections)
    db.flush()
    _audit(
        db,
        actor_id=actor.id,
        action="CREATE_JLPT_SIMULATION",
        simulation_id=simulation.id,
    )
    db.commit()
    return _query_simulation(db, simulation.id)


@router.get("/{simulation_id}", response_model=JlptSimulationResponse)
def get_simulation(
    simulation_id: str,
    db: Session = Depends(get_db),
    _: User = Depends(editor_only),
):
    return _query_simulation(db, simulation_id)


@router.patch("/{simulation_id}", response_model=JlptSimulationResponse)
def update_simulation(
    simulation_id: str,
    payload: JlptSimulationUpdate,
    db: Session = Depends(get_db),
    actor: User = Depends(editor_only),
):
    simulation = _query_simulation(db, simulation_id, lock=True)
    if simulation.is_published:
        raise HTTPException(status_code=409, detail="Unpublish the simulation before editing")
    if simulation.is_archived:
        raise HTTPException(status_code=409, detail="Archived simulations cannot be edited")
    if db.query(UserSimulationAttempt.id).filter(UserSimulationAttempt.simulation_id == simulation.id).first():
        raise HTTPException(
            status_code=409,
            detail="A simulation with attempts is immutable; archive it and create a new version",
        )

    changes = payload.model_dump(exclude_unset=True)
    sections = changes.pop("sections", None)
    for field_name, value in changes.items():
        setattr(simulation, field_name, value)
    if sections is not None:
        _replace_sections(db, simulation, payload.sections or [])
    _audit(
        db,
        actor_id=actor.id,
        action="UPDATE_JLPT_SIMULATION",
        simulation_id=simulation.id,
        details={"fields": sorted(payload.model_fields_set)},
    )
    db.commit()
    return _query_simulation(db, simulation.id)


@router.post("/{simulation_id}/publish", response_model=JlptSimulationResponse)
def publish_simulation(
    simulation_id: str,
    db: Session = Depends(get_db),
    actor: User = Depends(publisher_only),
):
    simulation = _query_simulation(db, simulation_id, lock=True)
    _ensure_publishable(simulation)
    if not simulation.is_published:
        simulation.is_published = True
        simulation.published_at = datetime.now(timezone.utc)
        _audit(
            db,
            actor_id=actor.id,
            action="PUBLISH_JLPT_SIMULATION",
            simulation_id=simulation.id,
        )
        db.commit()
    return _query_simulation(db, simulation.id)


@router.post("/{simulation_id}/unpublish", response_model=JlptSimulationResponse)
def unpublish_simulation(
    simulation_id: str,
    db: Session = Depends(get_db),
    actor: User = Depends(publisher_only),
):
    simulation = _query_simulation(db, simulation_id, lock=True)
    if simulation.is_published:
        simulation.is_published = False
        _audit(
            db,
            actor_id=actor.id,
            action="UNPUBLISH_JLPT_SIMULATION",
            simulation_id=simulation.id,
        )
        db.commit()
    return _query_simulation(db, simulation.id)


@router.delete("/{simulation_id}", response_model=JlptSimulationResponse)
def archive_simulation(
    simulation_id: str,
    db: Session = Depends(get_db),
    actor: User = Depends(editor_only),
):
    simulation = _query_simulation(db, simulation_id, lock=True)
    if simulation.is_published:
        raise HTTPException(status_code=409, detail="Unpublish the simulation before archiving")
    if not simulation.is_archived:
        simulation.is_archived = True
        _audit(
            db,
            actor_id=actor.id,
            action="ARCHIVE_JLPT_SIMULATION",
            simulation_id=simulation.id,
        )
        db.commit()
    return _query_simulation(db, simulation.id)


@router.get("/{simulation_id}/analytics", response_model=SimulationAnalyticsResponse)
def get_simulation_analytics(
    simulation_id: str,
    db: Session = Depends(get_db),
    _: User = Depends(editor_only),
):
    _query_simulation(db, simulation_id)
    attempt_count, completion_count, pass_count, average_score = (
        db.query(
            func.count(UserSimulationAttempt.id),
            func.sum(case((UserSimulationAttempt.status == "COMPLETED", 1), else_=0)),
            func.sum(case((UserSimulationAttempt.is_passed.is_(True), 1), else_=0)),
            func.avg(
                case(
                    (UserSimulationAttempt.status == "COMPLETED", UserSimulationAttempt.total_score),
                    else_=None,
                )
            ),
        )
        .filter(UserSimulationAttempt.simulation_id == simulation_id)
        .one()
    )
    return {
        "simulation_id": simulation_id,
        "attempt_count": int(attempt_count or 0),
        "completion_count": int(completion_count or 0),
        "pass_count": int(pass_count or 0),
        "average_score": round(float(average_score or 0), 2),
    }
