"""Canonical learner audio router.

The module name is retained because the application already imports
``app.api.v1.content``. Its routes follow the PRD path `/api/v1/audio/*`.
"""

from app.api.v1.audio import router

__all__ = ["router"]
