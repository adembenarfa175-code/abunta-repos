#!/bin/bash

# دالة لتوليد ملفات الفهرس بتنسيق احترافي
generate_index() {
    local dir=$1
    local title="Index of ${dir#./}"
    
    # حساب المسار النسبي للوصول للأيقونات من أي مجلد فرعي
    local depth=$(echo "${dir#./}" | tr -cd '/' | wc -c)
    local rel_path="."
    if [ "$dir" != "." ]; then
        rel_path=".."
        for ((i=1; i<depth; i++)); do rel_path="../$rel_path"; done
    fi

    # أيقوناتك التي حددتها
    local folder_icon="${rel_path}/folder.png"
    local file_icon="${rel_path}/deb-file.png"

    cat <<EOF > "$dir/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Abunta Repository | $title</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Ubuntu:wght@400;700&display=swap">
    <style>
        :root {
            --bg-color: #111111;
            --container-bg: #1a1a1a;
            --text-color: #eeeeee;
            --accent-color: #e95420; /* لون أوبونتو البرتقالي المميز */
            --border-color: #333333;
            --hover-bg: #262626;
        }

        body {
            font-family: 'Ubuntu', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 40px 20px;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: var(--container-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .header {
            padding: 20px 30px;
            background: var(--hover-bg);
            border-bottom: 2px solid var(--accent-color);
        }

        .header h1 {
            margin: 0;
            font-size: 1.2rem;
            color: var(--accent-color);
            letter-spacing: 0.5px;
        }

        .file-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .file-item {
            border-bottom: 1px solid var(--border-color);
            transition: background 0.2s ease;
        }

        .file-item:last-child { border-bottom: none; }

        .file-item:hover {
            background: var(--hover-bg);
        }

        .file-item a {
            display: flex;
            align-items: center;
            padding: 12px 30px;
            text-decoration: none;
            color: var(--text-color);
            font-size: 14px;
        }

        .file-item img {
            width: 22px;
            height: 22px;
            margin-right: 15px;
        }

        .parent-link {
            background: #222;
            font-weight: bold;
        }

        .footer {
            padding: 15px;
            text-align: center;
            font-size: 11px;
            color: #666;
            text-transform: uppercase;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>$title</h1>
        </div>
        <ul class="file-list">
            <li class="file-item parent-link">
                <a href=".."><span>⤴ .. (Parent Directory)</span></a>
            </li>
EOF

    # إضافة الملفات والمجلدات
    for item in "$dir"/*; do
        local name=$(basename "$item")
        # تجاهل ملفات النظام والسكربت
        if [[ "$name" != "index.html" && "$name" != "generate_indexes.sh" && "$name" != ".git" && "$name" != "folder.png" && "$name" != "deb-file.png" && "$name" != "conf" && "$name" != "db" ]]; then
            if [[ -d "$item" ]]; then
                echo "            <li class='file-item'><a href='$name/'><img src='$folder_icon' alt='dir'> $name/</a></li>" >> "$dir/index.html"
            else
                echo "            <li class='file-item'><a href='$name'><img src='$file_icon' alt='file'> $name</a></li>" >> "$dir/index.html"
            fi
        fi
    done

    cat <<EOF >> "$dir/index.html"
        </ul>
        <div class="footer">
            Abunta Project Repository &copy; 2025
        </div>
    </div>
</body>
</html>
EOF
}

# التنفيذ
export -f generate_index
find . -type d -not -path '*/.*' -exec bash -c 'generate_index "$0"' {} \;

echo "Index generation complete with Ubuntu font and Orange accents."
