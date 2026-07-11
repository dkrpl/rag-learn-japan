import sys
import os
import uuid
import asyncio

# Ensure project root is in PYTHONPATH
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.simulation import JlptSimulation, JlptSimulationSection, JlptSimulationQuestion
from app.models.question import Question, QuestionStatus

# Ensure all models are registered
import app.db.base 

def seed_simulation(db: Session):
    print("Mencari soal N5 yang sudah diterbitkan...")
    questions = db.query(Question).filter(Question.status == QuestionStatus.PUBLISHED).limit(33).all()
    if len(questions) < 5:
        print(f"Peringatan: Soal N5 tidak mencukupi. Ditemukan: {len(questions)}")
        # We will use what we have for MVP
        
    print("Menghapus simulasi N5 lama (jika ada)...")
    db.query(JlptSimulation).filter(JlptSimulation.level == "N5").delete()
    db.commit()

    print("Membuat simulasi N5 baru...")
    sim = JlptSimulation(
        id=str(uuid.uuid4()),
        title="Simulasi JLPT N5 Lengkap (MVP)",
        description="Simulasi penuh dengan 3 seksi: Kosakata, Tata Bahasa, dan Mendengarkan.",
        level="N5",
        passing_score=80,
        is_published=True
    )
    db.add(sim)
    
    sections_def = [
        {"title": "Vocabulary & Kanji", "type": "VOCABULARY_KANJI", "duration": 25},
        {"title": "Grammar & Reading", "type": "GRAMMAR_READING", "duration": 50},
        {"title": "Listening", "type": "LISTENING", "duration": 30}
    ]
    
    q_index = 0
    total_q = len(questions)
    
    for idx, s_def in enumerate(sections_def):
        sec = JlptSimulationSection(
            id=str(uuid.uuid4()),
            simulation_id=sim.id,
            title=s_def["title"],
            section_type=s_def["type"],
            sequence=idx + 1,
            duration_minutes=s_def["duration"],
            passing_score=19
        )
        db.add(sec)
        db.flush()
        
        # Bagi rata jumlah soal yang ada ke setiap seksi
        if total_q > 0:
            share = max(1, total_q // 3)
            # Jika seksi terakhir, ambil sisa soal
            if idx == 2:
                q_list = questions[q_index:]
            else:
                q_list = questions[q_index:q_index+share]
                
            for order, q in enumerate(q_list):
                sq = JlptSimulationQuestion(
                    id=str(uuid.uuid4()),
                    section_id=sec.id,
                    question_id=q.id,
                    order_number=order + 1
                )
                db.add(sq)
                
            q_index += share

    db.commit()
    print("✅ Berhasil membuat simulasi N5.")

if __name__ == "__main__":
    db = SessionLocal()
    try:
        seed_simulation(db)
    finally:
        db.close()
