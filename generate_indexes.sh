#!/bin/bash

# دالة لتوليد ملف index.html احترافي باللغة الإنجليزية
generate_index() {
    local dir=$1
    local title="Abunta Repository - ${dir#./}"
    
    # حساب المسار الصحيح لمجلد الأيقونات (icon) من أي مكان في المستودع
    local depth=$(echo "${dir#./}" | tr -cd '/' | wc -c)
    if [ "$dir" == "." ]; then
        rel_icon_path="./icon"
    else
        rel_icon_path="icon"
        for ((i=0; i<depth; i++)); do rel_icon_path="../$rel_icon_path"; done
    fi

    cat <<EOF > "$dir/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Ubuntu:wght@400;700&display=swap">
    <style>
        :root {
            --bg: #0c0c0c; --card: #181818; --accent: #e95420;
            --text: #f5f5f5; --dim: #888; --border: #2a2a2a;
        }
        body { font-family: 'Ubuntu', sans-serif; backgxround: var(--bg); color: var(--text); margin: 0; padding: 20px; display: flex; justify-content: center; }
        .wrapper { width: 100%; max-width: 1000px; background: var(--card); border-radius: 12px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 15px 35px rgba(0,0,0,0.7); }
        .header { padding: 20px 30px; background: #222; border-bottom: 3px solid var(--accent); }
        .header h1 { margin: 0; font-size: 1.2rem; color: var(--accent); }
        .list { list-style: none; padding: 0; margin: 0; }
        .item { display: flex; align-items: center; padding: 12px 25px; border-bottom: 1px solid var(--border); text-decoration: none; color: var(--text); transition: 0.2s; }
        .item:hover { background: #252525; padding-left: 35px; border-left: 4px solid var(--accent); }
        .item img { width: 22px; height: 22px; margin-right: 15px; }
        .parent { background: #111; font-weight: bold; color: var(--accent); }
        .footer { padding: 15px; text-align: center; font-size: 11px; color: var(--dim); background: #141414; letter-spacing: 1px; }
        .name { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="header"><h1>$title</h1></div>
        <div class="list">
            <a href=".." class="item parent"><img src="${rel_icon_path}/folder.png" style="filter: brightness(1.5);"> ⤴ Parent Directory</a>
EOF

    # إضافة المحتويات (مجلدات ثم ملفات)
    for item in "$dir"/*; do
        local name=$(basename "$item")
        
        # استثناء الملفات الحساسة والتقنية
        if [[ "$name" != "index.html" && "$name" != "generate_indexes.sh" && "$name" != ".git" && "$name" != "icon" && "$name" != "conf" && "$name" != "db" ]]; then
            
            local icon_file="file.png"
            if [[ -d "$item" ]]; then
                icon_file="folder.png"
                display_name="$name/"
            elif [[ "$name" == *.deb ]]; then
                icon_file="deb.png"
            elif [[ "$name" == *.gz || "$name" == *.zip || "$name" == *.xz ]]; then
                icon_file="zip.png"
            else
                display_name="$name"
            fi

            echo "            <a href='$name' class='item'><img src='${rel_icon_path}/$icon_file' alt='icon'><span class='name'>$display_name</span></a>" >> "$dir/index.html"
        fi
    done

    cat <<EOF >> "$dir/index.html"
        </div>
        <div class="footer">ABUNTA OS PROJECT REPOSITORY &bull; 2025</div>
    </div>
</body>
</html>
EOF
}

# تصدير الدالة لتستخدم مع find
export -f generate_index

# العثور على كل المجلدات وتحديث ملفات HTML داخلها
find . -type d -not -path '*/.*' -exec bash -c 'generate_index "$0"' {} \;

echo "------------------------------------------------"
echo "✅ All index.html files in the repository have been updated!"
echo "✅ Everything is now organized and English-ready."
echo "------------------------------------------------"
