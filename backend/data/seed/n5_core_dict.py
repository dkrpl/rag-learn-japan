VOCAB_BASES = [
    ("私", "わたし", "watashi", "I, myself"),
    ("先生", "せんせい", "sensei", "Teacher"),
    ("学生", "がくせい", "gakusei", "Student"),
    ("学校", "がっこう", "gakkou", "School"),
    ("会社", "かいしゃ", "kaisha", "Company"),
    ("今日", "きょう", "kyou", "Today"),
    ("明日", "あした", "ashita", "Tomorrow"),
    ("昨日", "きのう", "kinou", "Yesterday"),
    ("食べる", "たべる", "taberu", "To eat"),
    ("飲む", "のむ", "nomu", "To drink"),
    ("行く", "いく", "iku", "To go"),
    ("来る", "くる", "kuru", "To come"),
    ("見る", "みる", "miru", "To see"),
    ("聞く", "きく", "kiku", "To listen, hear"),
    ("話す", "はなす", "hanasu", "To speak"),
    ("読む", "よむ", "yomu", "To read"),
    ("書く", "かく", "kaku", "To write"),
    ("買う", "かう", "kau", "To buy"),
    ("大きい", "おおきい", "ookii", "Big"),
    ("小さい", "ちいさい", "chiisai", "Small"),
    ("新しい", "あたらしい", "atarashii", "New"),
    ("古い", "ふるい", "furui", "Old"),
    ("高い", "たかい", "takai", "High, expensive"),
    ("安い", "やすい", "yasui", "Cheap"),
    ("犬", "いぬ", "inu", "Dog"),
    ("猫", "ねこ", "neko", "Cat"),
    ("本", "ほん", "hon", "Book"),
    ("水", "みず", "mizu", "Water"),
    ("車", "くるま", "kuruma", "Car"),
    ("電車", "でんしゃ", "densha", "Train"),
]

KANJI_BASES = [
    ("日", "ニチ, ジツ", "ひ, -び, -か", "Day, sun", 4),
    ("月", "ゲツ, ガツ", "つき", "Month, moon", 4),
    ("火", "カ", "ひ, -び, ほ-", "Fire", 4),
    ("水", "スイ", "みず", "Water", 4),
    ("木", "ボク, モク", "き, こ-", "Tree, wood", 4),
    ("金", "キン, コン", "かね, かな-", "Gold, money", 8),
    ("土", "ド, ト", "つち", "Earth, soil", 3),
    ("人", "ジン, ニン", "ひと", "Person", 2),
    ("大", "ダイ, タイ", "おお-, おお.きい, おお.いに", "Large, big", 3),
    ("小", "ショウ", "ちい.さい, こ-, お-, さ-", "Little, small", 3),
    ("一", "イチ, イツ", "ひと-, ひと.つ", "One", 1),
    ("二", "ニ, ジ", "ふた, ふた.つ, ふたた.び", "Two", 2),
    ("三", "サン, ゾウ", "み, み.つ, みっ.つ", "Three", 3),
    ("四", "シ", "よ, よ.つ, よっ.つ, よん", "Four", 5),
    ("五", "ゴ", "いつ, いつ.つ", "Five", 4),
]

GRAMMAR_BASES = [
    ("NはNです", "N は N です", "N is N", "Basic identification."),
    ("NのN", "N の N", "N's N (Possessive)", "Links two nouns."),
    ("Vます", "Verb-ます", "Do Verb (Polite)", "Polite non-past affirmative."),
    ("Vません", "Verb-ません", "Do not Verb (Polite)", "Polite non-past negative."),
    ("Vました", "Verb-ました", "Did Verb (Polite)", "Polite past affirmative."),
    ("Nに", "N に", "At/In/To N", "Particle indicating time or destination."),
    ("NをV", "N を Verb", "Object marker", "Particle indicating direct object."),
    ("Nが", "N が", "Subject marker", "Particle indicating subject."),
    ("〜から〜まで", "〜から 〜まで", "From ~ to ~", "Indicates starting and ending points."),
    ("Vたい", "Verb-たい", "Want to Verb", "Indicates desire to perform an action."),
]

SENTENCE_BASES = [
    ("私は学生です。", "Watashi wa gakusei desu.", "I am a student."),
    ("これは私の本です。", "Kore wa watashi no hon desu.", "This is my book."),
    ("明日、東京に行きます。", "Ashita, Tokyo ni ikimasu.", "I will go to Tokyo tomorrow."),
    ("きのう、りんごを食べました。", "Kinou, ringo o tabemashita.", "I ate an apple yesterday."),
    ("あの車は高いです。", "Ano kuruma wa takai desu.", "That car is expensive."),
    ("水を飲みます。", "Mizu o nomimasu.", "I drink water."),
    ("日本語を勉強します。", "Nihongo o benkyou shimasu.", "I study Japanese."),
    ("猫がいます。", "Neko ga imasu.", "There is a cat."),
    ("学校はどこですか。", "Gakkou wa doko desu ka.", "Where is the school?"),
    ("今、何時ですか。", "Ima, nanji desu ka.", "What time is it now?"),
]

READING_BASES = [
    (
        "私の家族",
        "私の家族は4人です。父と母と姉と私です。父は会社員です。母は先生です。姉は大学生です。私は高校生です。私達は東京に住んでいます。",
        (
            "My family has 4 people. My father, mother, older sister, and me. "
            "My father is an office worker. My mother is a teacher. "
            "My older sister is a university student. I am a high school student. We live in Tokyo."
        ),
    ),
    (
        "休日の予定",
        "明日は日曜日です。私は友達と映画を見に行きます。その後、レストランで昼ごはんを食べます。午後はデパートで買い物をします。とても楽しみです。",
        (
            "Tomorrow is Sunday. I will go see a movie with my friend. "
            "After that, we will eat lunch at a restaurant. In the afternoon, "
            "we will go shopping at a department store. I am looking forward to it."
        ),
    ),
    (
        "日本語の勉強",
        "私は毎日日本語を勉強しています。漢字は難しいですが、面白いです。週末はアニメを見て日本語を聞きます。いつか日本に行きたいです。",
        (
            "I study Japanese every day. Kanji is difficult, but interesting. "
            "On weekends, I watch anime and listen to Japanese. I want to go to Japan someday."
        ),
    ),
]


def generate_vocabs(count):
    res = []
    for i in range(count):
        base = VOCAB_BASES[i % len(VOCAB_BASES)]
        mult = (i // len(VOCAB_BASES)) + 1
        suffix = f" {mult}" if mult > 1 else ""
        res.append({"word": base[0] + suffix, "kana": base[1], "romaji": base[2], "meaning": base[3] + suffix})
    return res


def generate_kanjis(count):
    res = []
    for i in range(count):
        base = KANJI_BASES[i % len(KANJI_BASES)]
        mult = (i // len(KANJI_BASES)) + 1
        suffix = str(mult) if mult > 1 else ""
        res.append(
            {
                "character": base[0] + suffix,
                "onyomi": base[1],
                "kunyomi": base[2],
                "meaning": base[3] + suffix,
                "stroke_count": base[4],
            }
        )
    return res


def generate_grammar(count):
    res = []
    for i in range(count):
        base = GRAMMAR_BASES[i % len(GRAMMAR_BASES)]
        mult = (i // len(GRAMMAR_BASES)) + 1
        suffix = f" {mult}" if mult > 1 else ""
        res.append({"title": base[0] + suffix, "structure": base[1], "meaning": base[2], "explanation": base[3]})
    return res


def generate_sentences(count):
    res = []
    for i in range(count):
        base = SENTENCE_BASES[i % len(SENTENCE_BASES)]
        mult = (i // len(SENTENCE_BASES)) + 1
        suffix = f" ({mult})" if mult > 1 else ""
        res.append({"japanese": base[0] + suffix, "romaji": base[1], "indonesian": base[2] + suffix})
    return res


def generate_readings(count):
    res = []
    for i in range(count):
        base = READING_BASES[i % len(READING_BASES)]
        mult = (i // len(READING_BASES)) + 1
        suffix = f" {mult}" if mult > 1 else ""
        res.append({"title": base[0] + suffix, "content": base[1], "translation": base[2]})
    return res
