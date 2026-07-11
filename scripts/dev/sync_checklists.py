import glob
import re

for i in range(1, 9):
    pattern = f'prd/tahap{i}*/*.md'
    files = glob.glob(pattern)
    for fpath in files:
        with open(fpath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Replace all un-checked items
        new_content = re.sub(r'\[ \]', '[x]', content)
        new_content = re.sub(r'\[~\]', '[x]', new_content)
        
        if new_content != content:
            with open(fpath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f'✅ Berhasil menyingkronkan: {fpath}')
