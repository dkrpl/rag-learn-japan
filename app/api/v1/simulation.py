from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session, selectinload

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.simulation import JlptSimulation, JlptSimulationSection
from app.models.user import User
from app.schemas.simulation import (
    JlptSimulationListResponse,
    JlptSimulationResponse,
    SimulationAttemptHistoryItem,
    SimulationAttemptResponse,
    SimulationResultResponse,
    SubmitSimulationAnswerRequest,
)
from app.services.simulation_attempt_service import SimulationAttemptService

router = APIRouter()


def _published_simulation_query(db: Session):
    return (
        db.query(JlptSimulation)
        .options(
            selectinload(JlptSimulation.sections).selectinload(
                JlptSimulationSection.questions
            )
        )
        .filter(
            JlptSimulation.is_published.is_(True),
            JlptSimulation.is_archived.is_(False),
        )
    )


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


@router.get("/jlpt-simulations", response_model=list[JlptSimulationListResponse])
def list_published_simulations(
    level: str | None = Query(default=None, pattern="^N[1-5]$"),
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=50, ge=1, le=100),
    db: Session = Depends(get_db),
    _: User = Depends(get_current_user),
):
    query = _published_simulation_query(db)
    if level:
        query = query.filter(JlptSimulation.level == level)
    simulations = query.order_by(JlptSimulation.created_at.desc()).offset(offset).limit(limit).all()
    return [_list_item(simulation) for simulation in simulations]


@router.get("/jlpt-simulations/{simulation_id}", response_model=JlptSimulationResponse)
def get_simulation_details(
    simulation_id: str,
    db: Session = Depends(get_db),
    _: User = Depends(get_current_user),
):
    simulation = _published_simulation_query(db).filter(
        JlptSimulation.id == simulation_id
    ).first()
    if simulation is None:
        raise HTTPException(status_code=404, detail="Simulation not found")
    return simulation


@router.post(
    "/jlpt-simulations/{simulation_id}/attempts",
    response_model=SimulationAttemptResponse,
    status_code=status.HTTP_201_CREATED,
)
def start_simulation_attempt(
    simulation_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.create_attempt(
        db,
        user_id=current_user.id,
        simulation_id=simulation_id,
    )


@router.get(
    "/jlpt-simulation-attempts/history",
    response_model=list[SimulationAttemptHistoryItem],
)
def list_simulation_attempts(
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.list_attempts(
        db,
        user_id=current_user.id,
        offset=offset,
        limit=limit,
    )


@router.get(
    "/jlpt-simulation-attempts/{attempt_id}",
    response_model=SimulationAttemptResponse,
)
def get_simulation_attempt(
    attempt_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.get_attempt(
        db,
        attempt_id=attempt_id,
        user_id=current_user.id,
    )


@router.post(
    "/jlpt-simulation-attempts/{attempt_id}/start-section",
    response_model=SimulationAttemptResponse,
)
def start_current_section(
    attempt_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.start_next_section(
        db,
        attempt_id=attempt_id,
        user_id=current_user.id,
    )


@router.post("/jlpt-simulation-attempts/{attempt_id}/answers")
def submit_answer(
    attempt_id: str,
    payload: SubmitSimulationAnswerRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    SimulationAttemptService.submit_answer(
        db,
        attempt_id=attempt_id,
        user_id=current_user.id,
        question_id=payload.question_id,
        answer_data=payload.answer_data,
        response_time_ms=payload.response_time_ms,
    )
    return {"message": "Answer saved"}


@router.post(
    "/jlpt-simulation-attempts/{attempt_id}/complete-section",
    response_model=SimulationAttemptResponse,
)
def complete_current_section(
    attempt_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.complete_current_section(
        db,
        attempt_id=attempt_id,
        user_id=current_user.id,
    )


@router.post(
    "/jlpt-simulation-attempts/{attempt_id}/complete",
    response_model=SimulationResultResponse,
)
def complete_simulation(
    attempt_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.complete_simulation(
        db,
        attempt_id=attempt_id,
        user_id=current_user.id,
    )


@router.get(
    "/jlpt-simulation-attempts/{attempt_id}/result",
    response_model=SimulationResultResponse,
)
def get_simulation_result(
    attempt_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.get_result(
        db,
        attempt_id=attempt_id,
        user_id=current_user.id,
    )


@router.delete(
    "/jlpt-simulation-attempts/{attempt_id}",
    response_model=SimulationAttemptResponse,
)
def cancel_simulation_attempt(
    attempt_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return SimulationAttemptService.cancel_attempt(
        db,
        attempt_id=attempt_id,
        user_id=current_user.id,
    )
