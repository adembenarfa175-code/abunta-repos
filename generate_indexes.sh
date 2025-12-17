#!/bin/bash

# دالة لإنشاء ملف index.html بتصميم احترافي
generate_index() {
    local dir=$1
    local title="Abunta Repository - ${dir#./}"
    local root_path=$(realpath --relative-to="$dir" .)
    
    # تحديد مسار الأيقونات بالنسبة للمجلد الحالي
    local folder_icon="${root_path}/folder.png"
    local file_icon="${root_path}/deb-file.png"

    cat <<EOF > "$dir/index.html"
<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #1a1a1a; color: #e0e0e0; margin: 0; padding: 20px; }
        .container { max-width: 900px; margin: auto; background: #2d2d2d; padding: 20px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.5); }
        h1 { color: #4db8ff; border-bottom: 2px solid #4db8ff; padding-bottom: 10px; font-size: 24px; }
        ul { list-style: none; padding: 0; }
        li { display: flex; align-items: center; padding: 10px; border-bottom: 1px solid #3d3d3d; transition: background 0.2s; }
        li:hover { background: #383838; }
        a { text-decoration: none; color: #ffffff; flex-grow: 1; display: flex; align-items: center; }
        img { width: 24px; height: 24px; margin-right: 15px; }
        .parent { color: #ffcc00; font-weight: bold; }
        footer { margin-top: 20px; text-align: center; font-size: 12px; color: #888; }
    </style>
</head>
<body>
    <div class="container">
        <h1>$title</h1>
        <ul>
            <li><a href=".." class="parent">⬅ العودة للمجلد السابق</a></li>
EOF

    # البحث عن المجلدات والملفات
    for item in "$dir"/*; do
        local name=$(basename "$item")
        # تجاهل الملفات التقنية index و git و السكربت والأيقونات نفسها
        if [[ "$name" != "index.html" && "$name" != "generate_indexes.sh" && "$name" != ".git" && "$name" != "folder.png" && "$name" != "deb-file.png" ]]; then
            if [[ -d "$item" ]]; then
                echo "            <li><a href='$name/'><img src='$folder_icon' alt='dir'> $name/</a></li>" >> "$dir/index.html"
            else
                echo "            <li><a href='$name'><img src='$file_icon' alt='file'> $name</a></li>" >> "$dir/index.html"
            fi
        fi
    done

    cat <<EOF >> "$dir/index.html"
        </ul>
        <footer>Abunta Project Repository &copy; 2025</footer>
    </div>
</body>
</html>
EOF
}

# البدء بالمرور على كل المجلدات
export -f generate_index
find . -type d -not -path '*/.*' -exec bash -c 'generate_index "$0"' {} \;

echo "تم تحديث الواجهة بنجاح! جرب فتح المجلد في المتصفح الآن."
