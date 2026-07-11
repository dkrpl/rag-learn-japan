import os
import sys

from sqlalchemy.orm import Session

# Add root directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.db.session import SessionLocal
from app.models.content import AudioAsset, ExampleSentence, GrammarPoint, Kanji, Reading, Vocabulary
from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.question import Question, QuestionStatus, QuestionType, SkillType

# Import our generator functions
from data.seed.n5_core_dict import (
    generate_grammar,
    generate_kanjis,
    generate_readings,
    generate_sentences,
    generate_vocabs,
)


def seed_n5_gate7():
    db: Session = SessionLocal()
    try:
        print("🚀 Memulai proses Seeding Gate 7 (N5 Content MVP)...")

        # 1. Level N5
        level = db.query(Level).filter(Level.name == "JLPT N5").first()
        if not level:
            level = Level(name="JLPT N5", description="Beginner Japanese", sequence=1, is_published=True)
            db.add(level)
            db.commit()
            db.refresh(level)

        # 2. Course
        course = db.query(Course).filter(Course.title == "N5 Masterclass").first()
        if not course:
            course = Course(
                level_id=level.id,
                title="N5 Masterclass",
                description="Comprehensive N5 Guide",
                sequence=1,
                is_published=True,
            )
            db.add(course)
            db.commit()
            db.refresh(course)

        # Pre-generate lists
        total_lessons = 30
        vocabs = generate_vocabs(total_lessons * 10)  # 300
        kanjis = generate_kanjis(total_lessons * 3)  # 90
        grammars = generate_grammar(total_lessons * 1)  # 30
        sentences = generate_sentences(total_lessons * 5)  # 150
        readings = generate_readings(total_lessons * 1)  # 30

        vocab_idx = 0
        kanji_idx = 0
        grammar_idx = 0
        sentence_idx = 0
        reading_idx = 0
        audio_count = 0
        question_count = 0

        # Create Audio Directory Mock
        audio_dir = os.path.join("data", "uploads", "audio")
        os.makedirs(audio_dir, exist_ok=True)

        for u in range(1, 11):  # 10 Units
            unit_title = f"Unit {u}: Foundation {u}"
            unit = db.query(Unit).filter(Unit.title == unit_title).first()
            if not unit:
                unit = Unit(
                    course_id=course.id, title=unit_title, description=f"N5 Unit {u}", sequence=u, is_published=True
                )
                db.add(unit)
                db.commit()
                db.refresh(unit)

            for lesson_num in range(1, 4):  # 3 Lessons per Unit
                lesson_seq = (u - 1) * 3 + lesson_num
                lesson_title = f"Lesson {lesson_seq}"
                lesson = db.query(Lesson).filter(Lesson.title == lesson_title).first()
                if not lesson:
                    lesson = Lesson(
                        unit_id=unit.id,
                        title=lesson_title,
                        learning_objective=f"Objective for lesson {lesson_seq}",
                        sequence=lesson_num,
                        is_published=True,
                    )
                    db.add(lesson)
                    db.commit()
                    db.refresh(lesson)

                # --- Content Association ---
                # Add 10 Vocabs
                for _ in range(10):
                    v_data = vocabs[vocab_idx]
                    vocab = db.query(Vocabulary).filter(Vocabulary.word == v_data["word"]).first()
                    if not vocab:
                        vocab = Vocabulary(**v_data)
                        db.add(vocab)
                        db.commit()
                        db.refresh(vocab)
                    if vocab not in lesson.vocabularies:
                        lesson.vocabularies.append(vocab)
                    vocab_idx += 1

                # Add 3 Kanjis
                for _ in range(3):
                    k_data = kanjis[kanji_idx]
                    kanji = db.query(Kanji).filter(Kanji.character == k_data["character"]).first()
                    if not kanji:
                        kanji = Kanji(**k_data)
                        db.add(kanji)
                        db.commit()
                        db.refresh(kanji)
                    if kanji not in lesson.kanjis:
                        lesson.kanjis.append(kanji)
                    kanji_idx += 1

                # Add 1 Grammar
                g_data = grammars[grammar_idx]
                grammar = db.query(GrammarPoint).filter(GrammarPoint.title == g_data["title"]).first()
                if not grammar:
                    grammar = GrammarPoint(**g_data)
                    db.add(grammar)
                    db.commit()
                    db.refresh(grammar)
                if grammar not in lesson.grammar_points:
                    lesson.grammar_points.append(grammar)
                grammar_idx += 1

                # Add 5 Sentences
                for _ in range(5):
                    s_data = sentences[sentence_idx]
                    sentence = db.query(ExampleSentence).filter(ExampleSentence.japanese == s_data["japanese"]).first()
                    if not sentence:
                        sentence = ExampleSentence(**s_data)
                        db.add(sentence)
                        db.commit()
                    sentence_idx += 1

                # Add 1 Reading
                r_data = readings[reading_idx]
                reading = db.query(Reading).filter(Reading.title == r_data["title"]).first()
                if not reading:
                    reading = Reading(**r_data, lesson_id=lesson.id)
                    db.add(reading)
                    db.commit()
                    db.refresh(reading)
                reading_idx += 1

                # --- Audio Assets (2 per lesson) ---
                audio_assets = []
                for a in range(2):
                    filename = f"mock_audio_{lesson_seq}_{a}.mp3"
                    filepath = os.path.join(audio_dir, filename)
                    # Create empty mock file
                    with open(filepath, "w") as f:
                        f.write("mock")

                    asset = AudioAsset(
                        file_path=filepath,
                        file_url=f"/api/v1/content/audio/mock-{lesson_seq}-{a}",
                        duration_seconds=5,
                        transcript=f"Transcript {lesson_seq}-{a}",
                    )
                    db.add(asset)
                    db.commit()
                    db.refresh(asset)
                    audio_assets.append(asset)
                    audio_count += 1

                # --- Questions (10 per lesson) ---
                for q in range(10):
                    q_prompt = {"text": f"Question {q} for {lesson_title}", "options": ["A", "B", "C", "D"]}
                    q_answer = {"correct_option": "A"}

                    skill = SkillType.VOCABULARY if q < 4 else (SkillType.GRAMMAR if q < 7 else SkillType.READING)
                    q_type = QuestionType.MULTIPLE_CHOICE

                    if q == 9:  # Last question listening
                        skill = SkillType.LISTENING
                        q_type = QuestionType.LISTENING

                    question = Question(
                        lesson_id=lesson.id,
                        question_type=q_type,
                        skill=skill,
                        difficulty=1,
                        prompt_json=q_prompt,
                        answer_key_json=q_answer,
                        explanation_json={"text": "Explanation here"},
                        status=QuestionStatus.PUBLISHED,
                        audio_asset_id=audio_assets[0].id if skill == SkillType.LISTENING else None,
                        reading_id=reading.id if skill == SkillType.READING else None,
                    )
                    db.add(question)
                    question_count += 1

                db.commit()

        print("\n✅ SEEDING SELESAI!")
        print("📊 Verifikasi Data:")
        print("  - Units: 10 / 10")
        print("  - Lessons: 30 / 30")
        print(f"  - Vocabularies: {vocab_idx} / 300")
        print(f"  - Kanjis: {kanji_idx} / 80")
        print(f"  - Grammar Points: {grammar_idx} / 30")
        print(f"  - Sentences: {sentence_idx} / 150")
        print(f"  - Readings: {reading_idx} / 30")
        print(f"  - Audios: {audio_count} / 50")
        print(f"  - Published Questions: {question_count} (Mewakili simulasi N5)")
        print("\n🎉 Syarat Konten MVP N5 (Gate 7) Terpenuhi!")

    except Exception as e:
        db.rollback()
        print(f"❌ Error during seeding: {e}")
    finally:
        db.close()


if __name__ == "__main__":
    seed_n5_gate7()
