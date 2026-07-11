"""Administrative question-bank and explicit review-workflow endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker, get_current_user
from app.db.session import get_db
from app.models.question import QuestionStatus, QuestionType, SkillType
from app.models.user import User, UserRole
from app.schemas.question import (
    QuestionCreate,
    QuestionPage,
    QuestionResponseAdmin,
    QuestionReviewCreate,
    QuestionRevisionResponse,
    QuestionUpdate,
)
from app.services import question_workflow as workflow

router = APIRouter()
can_read = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.REVIEWER, UserRole.ADMINISTRATOR])
can_edit = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
can_review = RoleChecker([UserRole.REVIEWER, UserRole.ADMINISTRATOR])


def _raise_workflow_error(exc: workflow.QuestionWorkflowError) -> None:
    raise HTTPException(
        status_code=exc.status_code,
        detail={"code": exc.code, "message": exc.message},
    ) from exc


@router.post(
    "",
    response_model=QuestionResponseAdmin,
    status_code=status.HTTP_201_CREATED,
    operation_id="adminCreateQuestion",
    summary="Create a manual question draft",
)
def create_question(
    payload: QuestionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_edit),
):
    try:
        return workflow.create_question(db, payload, current_user)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.get(
    "",
    response_model=QuestionPage,
    operation_id="adminListQuestions",
    summary="Filter and paginate the question bank",
)
def list_questions(
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
    lesson_id: str | None = Query(default=None),
    skill: SkillType | None = Query(default=None),
    difficulty: int | None = Query(default=None, ge=1, le=5),
    question_status: QuestionStatus | None = Query(default=None, alias="status"),
    question_type: QuestionType | None = Query(default=None),
    is_ai_generated: bool | None = Query(default=None),
    db: Session = Depends(get_db),
    _: User = Depends(can_read),
):
    items, total, pages = workflow.paginate_questions(
        db,
        page=page,
        page_size=page_size,
        lesson_id=lesson_id,
        skill=skill,
        difficulty=difficulty,
        status=question_status,
        question_type=question_type,
        is_ai_generated=is_ai_generated,
    )
    return QuestionPage(items=items, page=page, page_size=page_size, total=total, pages=pages)


@router.get(
    "/{question_id}",
    response_model=QuestionResponseAdmin,
    operation_id="adminGetQuestion",
    summary="Get one question including internal review fields",
)
def get_question(
    question_id: str,
    db: Session = Depends(get_db),
    _: User = Depends(can_read),
):
    try:
        return workflow.get_question_or_error(db, question_id)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.patch(
    "/{question_id}",
    response_model=QuestionResponseAdmin,
    operation_id="adminUpdateQuestion",
    summary="Update an editable question and create a revision",
)
def update_question(
    question_id: str,
    payload: QuestionUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_edit),
):
    try:
        return workflow.update_question(db, question_id, payload, current_user)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.post(
    "/{question_id}/auto-validate",
    response_model=QuestionResponseAdmin,
    operation_id="adminAutoValidateQuestion",
    summary="Run deterministic validation and move a draft to AUTO_VALIDATED",
)
def auto_validate_question(
    question_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_edit),
):
    try:
        return workflow.auto_validate(db, question_id, current_user)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.post(
    "/{question_id}/submit-review",
    response_model=QuestionResponseAdmin,
    operation_id="adminSubmitQuestionForReview",
    summary="Move an AUTO_VALIDATED question to IN_REVIEW",
)
def submit_question_for_review(
    question_id: str,
    db: Session = Depends(get_db),
    _: User = Depends(can_edit),
):
    try:
        return workflow.submit_for_review(db, question_id)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


def _review_action(
    db: Session,
    question_id: str,
    payload: QuestionReviewCreate,
    current_user: User,
    target: QuestionStatus,
):
    if payload.status_given is not None and payload.status_given != target:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={"code": "REVIEW_ACTION_MISMATCH", "message": "status_given does not match this endpoint"},
        )
    try:
        return workflow.review_question(
            db,
            question_id,
            target=target,
            actor=current_user,
            notes=payload.notes,
        )
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.post(
    "/{question_id}/approve",
    response_model=QuestionResponseAdmin,
    operation_id="adminApproveQuestion",
    summary="Approve a question under review",
)
def approve_question(
    question_id: str,
    payload: QuestionReviewCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_review),
):
    return _review_action(db, question_id, payload, current_user, QuestionStatus.APPROVED)


@router.post(
    "/{question_id}/reject",
    response_model=QuestionResponseAdmin,
    operation_id="adminRejectQuestion",
    summary="Reject a question under review",
)
def reject_question(
    question_id: str,
    payload: QuestionReviewCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_review),
):
    return _review_action(db, question_id, payload, current_user, QuestionStatus.REJECTED)


@router.post(
    "/{question_id}/request-revision",
    response_model=QuestionResponseAdmin,
    operation_id="adminRequestQuestionRevision",
    summary="Return a question to its editor with required notes",
)
def request_question_revision(
    question_id: str,
    payload: QuestionReviewCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_review),
):
    return _review_action(db, question_id, payload, current_user, QuestionStatus.NEEDS_REVISION)


@router.post(
    "/{question_id}/publish",
    response_model=QuestionResponseAdmin,
    operation_id="adminPublishQuestion",
    summary="Publish an approved, valid question",
)
def publish_question(
    question_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_review),
):
    try:
        return workflow.publish_question(db, question_id, current_user)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.post(
    "/{question_id}/unpublish",
    response_model=QuestionResponseAdmin,
    operation_id="adminUnpublishQuestion",
    summary="Remove a published question from learner selection",
)
def unpublish_question(
    question_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _: User = Depends(can_review),
):
    try:
        return workflow.unpublish_question(db, question_id, current_user)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.post(
    "/{question_id}/archive",
    response_model=QuestionResponseAdmin,
    operation_id="adminArchiveQuestion",
    summary="Archive an unpublished question without deleting history",
)
def archive_question(
    question_id: str,
    db: Session = Depends(get_db),
    _: User = Depends(can_edit),
):
    try:
        return workflow.archive_question(db, question_id)
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)


@router.get(
    "/{question_id}/history",
    response_model=list[QuestionRevisionResponse],
    operation_id="adminGetQuestionHistory",
    summary="Get immutable question revisions",
)
def get_question_history(
    question_id: str,
    db: Session = Depends(get_db),
    _: User = Depends(can_read),
):
    try:
        question = workflow.get_question_or_error(db, question_id)
        return question.revisions
    except workflow.QuestionWorkflowError as exc:
        _raise_workflow_error(exc)
