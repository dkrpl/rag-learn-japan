import logging

from fastapi import Request, status
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException

logger = logging.getLogger("nihongo.errors")


def error_payload(request: Request, code: str, message: str, details: list | None = None) -> dict:
    return {
        "status": "error",
        "error": {
            "code": code,
            "message": message,
            "details": details or [],
            "request_id": getattr(request.state, "request_id", None),
        },
    }


async def validation_exception_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
    details = []
    for error in exc.errors():
        field = ".".join([str(loc) for loc in error["loc"]])
        details.append({"field": field, "message": error["msg"]})

    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=error_payload(request, "VALIDATION_ERROR", "Input validation failed", details),
    )


async def http_exception_handler(request: Request, exc: StarletteHTTPException) -> JSONResponse:
    detail = exc.detail
    if isinstance(detail, dict):
        code = str(detail.get("code") or f"HTTP_{exc.status_code}")
        message = str(detail.get("message") or "Request failed")
        details = detail.get("details") or []
    else:
        code = f"HTTP_{exc.status_code}"
        message = str(detail)
        details = []
    return JSONResponse(
        status_code=exc.status_code,
        content=error_payload(request, code, message, details),
        headers=getattr(exc, "headers", None),
    )


async def general_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    logger.exception("unhandled_exception", exc_info=exc)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=error_payload(request, "INTERNAL_SERVER_ERROR", "An unexpected error occurred"),
    )
