#!/bin/bash

# دالة لإنشاء ملف index.html في المجلد الحالي
generate_index() {
    local dir=$1
    local title="Index of ${dir#./}"
    
    echo "<html><head><title>$title</title></head><body>" > "$dir/index.html"
    echo "<h1>$title</h1><hr><ul>" >> "$dir/index.html"
    echo "<li><a href='..'>.. (Parent Directory)</a></li>" >> "$dir/index.html"

    # البحث عن الملفات والمجلدات وتجاهل index.html نفسه والسكربت
    for item in "$dir"/*; do
        local name=$(basename "$item")
        if [[ "$name" != "index.html" && "$name" != "generate_indexes.sh" && "$name" != ".git" ]]; then
            if [[ -d "$item" ]]; then
                echo "<li>[DIR] <a href='$name/'>$name/</a></li>" >> "$dir/index.html"
            else
                echo "<li>[FILE] <a href='$name'>$name</a></li>" >> "$dir/index.html"
            fi
        fi
    done

    echo "</ul><hr><footer>Abunta Project Repository Browser</footer></body></html>" >> "$dir/index.html"
}

# البدء بالمرور على كل المجلدات بشكل تكراري
export -f generate_index
find . -type d -not -path '*/.*' -exec bash -c 'generate_index "$0"' {} \;

echo "Done! All index.html files generated."
