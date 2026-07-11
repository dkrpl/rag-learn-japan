import logging
import time
import uuid

from starlette.datastructures import Headers
from starlette.types import ASGIApp, Message, Receive, Scope, Send

from app.core.logging import request_id_context

logger = logging.getLogger("nihongo.http")


class RequestContextMiddleware:
    def __init__(self, app: ASGIApp) -> None:
        self.app = app

    async def __call__(self, scope: Scope, receive: Receive, send: Send) -> None:
        if scope["type"] != "http":
            await self.app(scope, receive, send)
            return

        headers = Headers(scope=scope)
        request_id = headers.get("x-request-id") or str(uuid.uuid4())
        scope.setdefault("state", {})["request_id"] = request_id
        token = request_id_context.set(request_id)
        started = time.perf_counter()
        status_code = 500

        async def send_with_headers(message: Message) -> None:
            nonlocal status_code
            if message["type"] == "http.response.start":
                status_code = message["status"]
                response_headers = list(message.get("headers", []))
                response_headers.extend(
                    [
                        (b"x-request-id", request_id.encode("ascii", errors="ignore")),
                        (b"x-content-type-options", b"nosniff"),
                        (b"x-frame-options", b"DENY"),
                        (b"referrer-policy", b"no-referrer"),
                        (b"permissions-policy", b"camera=(), microphone=(), geolocation=()"),
                    ]
                )
                message["headers"] = response_headers
            await send(message)

        try:
            await self.app(scope, receive, send_with_headers)
        finally:
            duration_ms = round((time.perf_counter() - started) * 1000, 2)
            client = scope.get("client")
            logger.info(
                "request_completed",
                extra={
                    "http_method": scope.get("method"),
                    "http_path": scope.get("path"),
                    "status_code": status_code,
                    "duration_ms": duration_ms,
                    "client_ip": client[0] if client else None,
                },
            )
            request_id_context.reset(token)


class RequestBodyLimitMiddleware:
    def __init__(self, app: ASGIApp, max_bytes: int) -> None:
        self.app = app
        self.max_bytes = max_bytes

    async def __call__(self, scope: Scope, receive: Receive, send: Send) -> None:
        if scope["type"] != "http":
            await self.app(scope, receive, send)
            return

        headers = Headers(scope=scope)
        content_length = headers.get("content-length")
        try:
            too_large = bool(content_length and int(content_length) > self.max_bytes)
        except ValueError:
            too_large = False
        if too_large:
            await send(
                {
                    "type": "http.response.start",
                    "status": 413,
                    "headers": [(b"content-type", b"application/json")],
                }
            )
            await send(
                {
                    "type": "http.response.body",
                    "body": (
                        b'{"status":"error","error":{"code":"PAYLOAD_TOO_LARGE",'
                        b'"message":"Request body is too large","details":[]}}'
                    ),
                }
            )
            return
        await self.app(scope, receive, send)
