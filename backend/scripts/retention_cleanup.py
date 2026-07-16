"""Conservative data-retention cleanup for production operations.

Default mode is dry-run. Set APPLY_RETENTION=true to write changes.

Environment:
  RAW_AI_RESPONSE_RETENTION_DAYS=90
  APPLY_RETENTION=false
"""

from __future__ import annotations

import os
from datetime import datetime, timedelta, timezone

from app.db.session import SessionLocal
from app.models.ai_jobs import GenerationJob


def main() -> int:
    days = int(os.getenv("RAW_AI_RESPONSE_RETENTION_DAYS", "90"))
    apply_changes = os.getenv("APPLY_RETENTION", "false").lower() == "true"
    cutoff = datetime.now(timezone.utc) - timedelta(days=days)
    db = SessionLocal()
    try:
        query = db.query(GenerationJob).filter(
            GenerationJob.completed_at.isnot(None),
            GenerationJob.completed_at < cutoff,
            GenerationJob.raw_response.isnot(None),
        )
        count = query.count()
        print(f"Raw AI responses older than {days} days: {count}")
        if apply_changes and count:
            query.update({GenerationJob.raw_response: None}, synchronize_session=False)
            db.commit()
            print("Retention cleanup applied")
        else:
            print("Dry run only. Set APPLY_RETENTION=true to apply.")
        return 0
    finally:
        db.close()


if __name__ == "__main__":
    raise SystemExit(main())
