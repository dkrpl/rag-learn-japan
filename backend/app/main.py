import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.routing import APIRoute
from prometheus_fastapi_instrumentator import Instrumentator
from starlette.exceptions import HTTPException as StarletteHTTPException
from starlette.middleware.trustedhost import TrustedHostMiddleware

from app.core.config import settings
from app.core.exceptions import (
    general_exception_handler,
    http_exception_handler,
    validation_exception_handler,
)
from app.core.logging import configure_logging
from app.core.middleware import RequestBodyLimitMiddleware, RequestContextMiddleware
from app.core.security_headers import SecurityHeadersMiddleware

configure_logging()
logger = logging.getLogger("nihongo.app")


def custom_generate_unique_id(route: APIRoute) -> str:
    tag = route.tags[0].lower().replace(" ", "-") if route.tags else "api"
    path = route.path.strip("/").replace("/", "-").replace("{", "").replace("}", "") or "root"
    return f"{tag}-{route.name}-{path}"


@asynccontextmanager
async def lifespan(_: FastAPI):
    settings.AUDIO_STORAGE_PATH.mkdir(parents=True, exist_ok=True)
    logger.info(
        "application_started",
        extra={"environment": settings.ENVIRONMENT, "version": settings.VERSION},
    )
    yield
    logger.info("application_stopped")


def register_routers(app: FastAPI) -> None:
    from app.api.v1 import auth, content, curriculum, frontend, learning, progress, reviews, simulation, system, users
    from app.api.v1.admin import ai_jobs as admin_ai_jobs
    from app.api.v1.admin import content as admin_content
    from app.api.v1.admin import curriculum as admin_curriculum
    from app.api.v1.admin import questions as admin_questions
    from app.api.v1.admin import simulation as admin_simulation
    from app.api.v1.admin import users as admin_users

    app.include_router(system.router, prefix="/api/v1", tags=["System"], include_in_schema=False)
    app.include_router(auth.router, prefix="/api/v1/auth", tags=["Auth"])
    app.include_router(frontend.router, prefix="/api/v1/app", tags=["Frontend"])
    app.include_router(users.router, prefix="/api/v1/users", tags=["Users"], include_in_schema=False)
    app.include_router(curriculum.router, prefix="/api/v1/curriculum", tags=["Curriculum"], include_in_schema=False)
    app.include_router(content.router, prefix="/api/v1", tags=["Audio"], include_in_schema=False)
    app.include_router(
        learning.router,
        prefix="/api/v1/learning-sessions",
        tags=["Learning Sessions"],
        include_in_schema=False,
    )
    app.include_router(progress.router, prefix="/api/v1/progress", tags=["Progress"], include_in_schema=False)
    app.include_router(reviews.router, prefix="/api/v1/reviews", tags=["Reviews"], include_in_schema=False)
    app.include_router(
        admin_curriculum.router,
        prefix="/api/v1/admin/curriculum",
        tags=["Admin Curriculum"],
        include_in_schema=False,
    )
    app.include_router(
        admin_content.router,
        prefix="/api/v1/admin/content",
        tags=["Admin Content"],
        include_in_schema=False,
    )
    app.include_router(
        admin_questions.router,
        prefix="/api/v1/admin/questions",
        tags=["Admin Questions"],
        include_in_schema=False,
    )
    app.include_router(
        admin_ai_jobs.router,
        prefix="/api/v1/admin/generation-jobs",
        tags=["Admin AI Jobs"],
        include_in_schema=False,
    )
    app.include_router(admin_users.router, prefix="/api/v1/admin/users", tags=["Admin Users"], include_in_schema=False)
    app.include_router(
        admin_simulation.router,
        prefix="/api/v1/admin/jlpt-simulations",
        tags=["Admin JLPT Simulations"],
        include_in_schema=False,
    )
    app.include_router(simulation.router, prefix="/api/v1", tags=["JLPT Simulations"], include_in_schema=False)

    # Operational aliases follow the PRD and stay outside the versioned contract.
    app.add_api_route("/health", system.check_health, methods=["GET"], include_in_schema=False)
    app.add_api_route("/ready", system.check_readiness, methods=["GET"], include_in_schema=False)


def create_app() -> FastAPI:
    docs_url = "/docs" if settings.ENABLE_API_DOCS else None
    redoc_url = "/redoc" if settings.ENABLE_API_DOCS else None
    openapi_url = "/openapi.json" if settings.ENABLE_API_DOCS else None
    app = FastAPI(
        title=settings.PROJECT_NAME,
        description="Production backend for the RAG Learn Japan platform.",
        version=settings.VERSION,
        openapi_url=openapi_url,
        docs_url=docs_url,
        redoc_url=redoc_url,
        generate_unique_id_function=custom_generate_unique_id,
        lifespan=lifespan,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=settings.CORS_ALLOW_CREDENTIALS,
        allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
        allow_headers=["Authorization", "Content-Type", "X-Request-ID"],
        expose_headers=["X-Request-ID", "X-Response-Time-Ms"],
    )
    app.add_middleware(SecurityHeadersMiddleware)
    app.add_middleware(TrustedHostMiddleware, allowed_hosts=settings.ALLOWED_HOSTS)
    app.add_middleware(GZipMiddleware, minimum_size=1024)
    app.add_middleware(RequestBodyLimitMiddleware, max_bytes=settings.MAX_REQUEST_BODY_BYTES)
    app.add_middleware(RequestContextMiddleware)

    app.add_exception_handler(RequestValidationError, validation_exception_handler)
    app.add_exception_handler(StarletteHTTPException, http_exception_handler)
    app.add_exception_handler(Exception, general_exception_handler)

    register_routers(app)

    if settings.ENABLE_METRICS:
        Instrumentator(excluded_handlers=["/metrics", "/health", "/ready"]).instrument(app).expose(
            app,
            include_in_schema=False,
            should_gzip=True,
        )
    return app


app = create_app()
