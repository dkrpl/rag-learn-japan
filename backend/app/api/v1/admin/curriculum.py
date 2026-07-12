from __future__ import annotations

from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker
from app.db.session import get_db
from app.models.curriculum import Course, Lesson, LessonSection, Level, Unit
from app.models.user import UserRole
from app.schemas.curriculum import (
    CourseCreate,
    CourseResponse,
    CourseUpdate,
    LessonCreate,
    LessonDetailResponse,
    LessonResponse,
    LessonSectionCreate,
    LessonSectionResponse,
    LessonSectionUpdate,
    LessonUpdate,
    LevelCreate,
    LevelResponse,
    LevelUpdate,
    LifecycleActionResponse,
    UnitCreate,
    UnitResponse,
    UnitUpdate,
)
from app.services.curriculum_content_service import (
    DomainError,
    apply_lifecycle_from_input,
    archive,
    get_or_raise,
    publish,
    restore,
    unpublish,
)

admin_checker = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
router = APIRouter(dependencies=[Depends(admin_checker)])


def _raise_domain_error(exc: DomainError) -> None:
    raise HTTPException(status_code=exc.status_code, detail=str(exc)) from exc


def _commit(db: Session, conflict_message: str) -> None:
    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=conflict_message) from exc


def _create_resource(db: Session, model: type[Any], payload: Any) -> Any:
    values = payload.model_dump(exclude={"is_published"})
    requested_publish = payload.is_published
    try:
        resource = model(**values)
        db.add(resource)
        db.flush()
        apply_lifecycle_from_input(resource, requested_publish, db)
        _commit(db, f"{model.__name__} conflicts with an existing resource")
        db.refresh(resource)
        return resource
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)


def _update_resource(db: Session, model: type[Any], resource_id: str, payload: Any) -> Any:
    try:
        resource = get_or_raise(db, model, resource_id)
        values = payload.model_dump(exclude_unset=True)
        requested_publish = values.pop("is_published", None)
        for field, value in values.items():
            setattr(resource, field, value)
        db.flush()
        apply_lifecycle_from_input(resource, requested_publish, db)
        _commit(db, f"{model.__name__} conflicts with an existing resource")
        db.refresh(resource)
        return resource
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)


def _get_resource(db: Session, model: type[Any], resource_id: str) -> Any:
    try:
        return get_or_raise(db, model, resource_id)
    except DomainError as exc:
        _raise_domain_error(exc)


def _query_resources(
    db: Session,
    model: type[Any],
    *,
    include_archived: bool,
    is_published: bool | None,
    offset: int,
    limit: int,
) -> list[Any]:
    query = db.query(model)
    if not include_archived:
        query = query.filter(model.is_archived.is_(False))
    if is_published is not None:
        query = query.filter(model.is_published.is_(is_published))
    return query.order_by(model.sequence, model.created_at, model.id).offset(offset).limit(limit).all()


@router.post("/levels", response_model=LevelResponse, status_code=status.HTTP_201_CREATED)
def create_level(payload: LevelCreate, db: Session = Depends(get_db)):
    return _create_resource(db, Level, payload)


@router.get("/levels", response_model=list[LevelResponse])
def list_levels(
    include_archived: bool = False,
    is_published: bool | None = None,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    return _query_resources(
        db,
        Level,
        include_archived=include_archived,
        is_published=is_published,
        offset=offset,
        limit=limit,
    )


@router.get("/levels/{resource_id}", response_model=LevelResponse)
def get_level(resource_id: str, db: Session = Depends(get_db)):
    return _get_resource(db, Level, resource_id)


@router.patch("/levels/{resource_id}", response_model=LevelResponse)
@router.put("/levels/{resource_id}", response_model=LevelResponse, include_in_schema=False)
def update_level(resource_id: str, payload: LevelUpdate, db: Session = Depends(get_db)):
    return _update_resource(db, Level, resource_id, payload)


@router.post("/courses", response_model=CourseResponse, status_code=status.HTTP_201_CREATED)
def create_course(payload: CourseCreate, db: Session = Depends(get_db)):
    return _create_resource(db, Course, payload)


@router.get("/courses", response_model=list[CourseResponse])
def list_courses(
    level_id: str | None = None,
    include_archived: bool = False,
    is_published: bool | None = None,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = db.query(Course)
    if level_id:
        query = query.filter(Course.level_id == level_id)
    if not include_archived:
        query = query.filter(Course.is_archived.is_(False))
    if is_published is not None:
        query = query.filter(Course.is_published.is_(is_published))
    return query.order_by(Course.sequence, Course.created_at, Course.id).offset(offset).limit(limit).all()


@router.get("/courses/{resource_id}", response_model=CourseResponse)
def get_course(resource_id: str, db: Session = Depends(get_db)):
    return _get_resource(db, Course, resource_id)


@router.patch("/courses/{resource_id}", response_model=CourseResponse)
@router.put("/courses/{resource_id}", response_model=CourseResponse, include_in_schema=False)
def update_course(resource_id: str, payload: CourseUpdate, db: Session = Depends(get_db)):
    return _update_resource(db, Course, resource_id, payload)


@router.post("/units", response_model=UnitResponse, status_code=status.HTTP_201_CREATED)
def create_unit(payload: UnitCreate, db: Session = Depends(get_db)):
    return _create_resource(db, Unit, payload)


@router.get("/units", response_model=list[UnitResponse])
def list_units(
    course_id: str | None = None,
    include_archived: bool = False,
    is_published: bool | None = None,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = db.query(Unit)
    if course_id:
        query = query.filter(Unit.course_id == course_id)
    if not include_archived:
        query = query.filter(Unit.is_archived.is_(False))
    if is_published is not None:
        query = query.filter(Unit.is_published.is_(is_published))
    return query.order_by(Unit.sequence, Unit.created_at, Unit.id).offset(offset).limit(limit).all()


@router.get("/units/{resource_id}", response_model=UnitResponse)
def get_unit(resource_id: str, db: Session = Depends(get_db)):
    return _get_resource(db, Unit, resource_id)


@router.patch("/units/{resource_id}", response_model=UnitResponse)
@router.put("/units/{resource_id}", response_model=UnitResponse, include_in_schema=False)
def update_unit(resource_id: str, payload: UnitUpdate, db: Session = Depends(get_db)):
    return _update_resource(db, Unit, resource_id, payload)


@router.post("/lessons", response_model=LessonResponse, status_code=status.HTTP_201_CREATED)
def create_lesson(payload: LessonCreate, db: Session = Depends(get_db)):
    return _create_resource(db, Lesson, payload)


@router.get("/lessons", response_model=list[LessonResponse])
def list_lessons(
    unit_id: str | None = None,
    include_archived: bool = False,
    is_published: bool | None = None,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = db.query(Lesson)
    if unit_id:
        query = query.filter(Lesson.unit_id == unit_id)
    if not include_archived:
        query = query.filter(Lesson.is_archived.is_(False))
    if is_published is not None:
        query = query.filter(Lesson.is_published.is_(is_published))
    return query.order_by(Lesson.sequence, Lesson.created_at, Lesson.id).offset(offset).limit(limit).all()


@router.get("/lessons/{resource_id}", response_model=LessonDetailResponse)
def get_lesson(resource_id: str, db: Session = Depends(get_db)):
    return _get_resource(db, Lesson, resource_id)


@router.patch("/lessons/{resource_id}", response_model=LessonResponse)
@router.put("/lessons/{resource_id}", response_model=LessonResponse, include_in_schema=False)
def update_lesson(resource_id: str, payload: LessonUpdate, db: Session = Depends(get_db)):
    return _update_resource(db, Lesson, resource_id, payload)


@router.post("/lessons/{lesson_id}/sections", response_model=LessonSectionResponse, status_code=status.HTTP_201_CREATED)
def create_lesson_section(lesson_id: str, payload: LessonSectionCreate, db: Session = Depends(get_db)):
    if payload.lesson_id and payload.lesson_id != lesson_id:
        raise HTTPException(status_code=422, detail="lesson_id does not match the path")
    values = payload.model_dump()
    values["lesson_id"] = lesson_id
    return _create_resource(db, LessonSection, LessonSectionCreate(**values))


@router.get("/lesson-sections", response_model=list[LessonSectionResponse])
def list_lesson_sections(
    lesson_id: str | None = None,
    include_archived: bool = False,
    is_published: bool | None = None,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = db.query(LessonSection)
    if lesson_id:
        query = query.filter(LessonSection.lesson_id == lesson_id)
    if not include_archived:
        query = query.filter(LessonSection.is_archived.is_(False))
    if is_published is not None:
        query = query.filter(LessonSection.is_published.is_(is_published))
    return (
        query.order_by(LessonSection.sequence, LessonSection.created_at, LessonSection.id)
        .offset(offset)
        .limit(limit)
        .all()
    )


@router.get("/lesson-sections/{resource_id}", response_model=LessonSectionResponse)
def get_lesson_section(resource_id: str, db: Session = Depends(get_db)):
    return _get_resource(db, LessonSection, resource_id)


@router.patch("/lesson-sections/{resource_id}", response_model=LessonSectionResponse)
@router.put("/lessons/sections/{resource_id}", response_model=LessonSectionResponse, include_in_schema=False)
def update_lesson_section(resource_id: str, payload: LessonSectionUpdate, db: Session = Depends(get_db)):
    return _update_resource(db, LessonSection, resource_id, payload)


CURRICULUM_RESOURCES: dict[str, type[Any]] = {
    "levels": Level,
    "courses": Course,
    "units": Unit,
    "lessons": Lesson,
    "lesson-sections": LessonSection,
}


def _lifecycle_action(db: Session, resource_type: str, resource_id: str, action: str) -> LifecycleActionResponse:
    model = CURRICULUM_RESOURCES[resource_type]
    try:
        resource = get_or_raise(db, model, resource_id)
        if action == "publish":
            publish(resource, db=db)
            state = "published"
        elif action == "unpublish":
            unpublish(resource)
            state = "draft"
        elif action == "archive":
            archive(resource)
            state = "archived"
        elif action == "restore":
            restore(resource)
            state = "draft"
        else:  # pragma: no cover - registration is static
            raise RuntimeError(f"unsupported lifecycle action: {action}")
        _commit(db, f"could not {action} {model.__name__}")
        return LifecycleActionResponse(id=resource.id, resource_type=resource_type, state=state)
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)


def _register_lifecycle_routes(resource_type: str) -> None:
    def publish_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "publish")

    def unpublish_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "unpublish")

    def archive_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "archive")

    def restore_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "restore")

    router.add_api_route(
        f"/{resource_type}/{{resource_id}}/publish",
        publish_resource,
        methods=["POST"],
        response_model=LifecycleActionResponse,
        name=f"publish_{resource_type}",
    )
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}/unpublish",
        unpublish_resource,
        methods=["POST"],
        response_model=LifecycleActionResponse,
        name=f"unpublish_{resource_type}",
    )
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}/archive",
        archive_resource,
        methods=["POST"],
        response_model=LifecycleActionResponse,
        name=f"archive_{resource_type}",
    )
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}/restore",
        restore_resource,
        methods=["POST"],
        response_model=LifecycleActionResponse,
        name=f"restore_{resource_type}",
    )
    # DELETE is a compatibility alias for a reversible archive, never a hard delete.
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}",
        archive_resource,
        methods=["DELETE"],
        response_model=LifecycleActionResponse,
        include_in_schema=False,
        name=f"delete_archives_{resource_type}",
    )


for _resource_type in CURRICULUM_RESOURCES:
    _register_lifecycle_routes(_resource_type)
