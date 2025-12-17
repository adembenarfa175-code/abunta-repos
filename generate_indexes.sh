#!/bin/bash

# Function to generate a professional index.html with Ubuntu styling
generate_index() {
    local dir=$1
    local title="Index of ${dir#./}"
    
    # Calculate relative path for icons to work in subdirectories
    local depth=$(echo "${dir#./}" | tr -cd '/' | wc -c)
    local rel_path="."
    if [ "$dir" != "." ]; then
        rel_path=".."
        for ((i=1; i<depth; i++)); do rel_path="../$rel_path"; done
    fi

    # Define your custom icons
    local folder_icon="${rel_path}/folder.png"
    local file_icon="${rel_path}/deb-file.png"

    cat <<EOF > "$dir/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Abunta Repo | $title</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Ubuntu:wght@400;700&display=swap">
    <style>
        :root {
            --bg-dark: #0c0c0c;
            --card-bg: #181818;
            --text-main: #f5f5f5;
            --text-dim: #a0a0a0;
            --accent: #e95420; /* Ubuntu Orange */
            --border: #2a2a2a;
            --hover-row: #222222;
        }

        body {
            font-family: 'Ubuntu', sans-serif;
            background-color: var(--bg-dark);
            color: var(--text-main);
            margin: 0;
            padding: 50px 20px;
            display: flex;
            justify-content: center;
        }

        .wrapper {
            width: 100%;
            max-width: 960px;
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.6);
            border: 1px solid var(--border);
            overflow: hidden;
        }

        .header {
            padding: 25px 35px;
            background: linear-gradient(to right, #1e1e1e, #181818);
            border-bottom: 3px solid var(--accent);
        }

        .header h1 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .list-container {
            padding: 10px 0;
        }

        .row {
            display: flex;
            align-items: center;
            padding: 14px 35px;
            text-decoration: none;
            color: var(--text-main);
            border-bottom: 1px solid var(--border);
            transition: all 0.2s ease-in-out;
        }

        .row:last-child { border-bottom: none; }

        .row:hover {
            background-color: var(--hover-row);
            padding-left: 45px;
        }

        .row img {
            width: 24px;
            height: 24px;
            margin-right: 18px;
        }

        .row .name {
            font-size: 15px;
            flex-grow: 1;
        }

        .parent-dir {
            background: #111;
            color: var(--accent);
            font-weight: 700;
            border-bottom: 2px solid var(--border);
        }

        .footer {
            padding: 20px;
            text-align: center;
            font-size: 11px;
            color: var(--text-dim);
            background: #141414;
            border-top: 1px solid var(--border);
            text-transform: uppercase;
            letter-spacing: 2px;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="header">
            <h1>$title</h1>
        </div>
        <div class="list-container">
            <a href=".." class="row parent-dir">
                <span>⤴ .. (Parent Directory)</span>
            </a>
EOF

    # Generate rows for Directories and Files
    for item in "$dir"/*; do
        local name=$(basename "$item")
        
        # Security: Exclude system files and icons from the listing
        if [[ "$name" != "index.html" && "$name" != "generate_indexes.sh" && "$name" != ".git" && "$name" != "folder.png" && "$name" != "deb-file.png" && "$name" != "conf" && "$name" != "db" ]]; then
            if [[ -d "$item" ]]; then
                echo "            <a href='$name/' class='row'><img src='$folder_icon' alt='folder'><span class='name'>$name/</span></a>" >> "$dir/index.html"
            else
                echo "            <a href='$name' class='row'><img src='$file_icon' alt='file'><span class='name'>$name</span></a>" >> "$dir/index.html"
            fi
        fi
    done

    cat <<EOF >> "$dir/index.html"
        </div>
        <div class="footer">
            Abunta OS Repository &bull; Powered by Reprepro &bull; 2025
        </div>
    </div>
</body>
</html>
EOF
}

# Run the generation process
export -f generate_index
find . -type d -not -path '*/.*' -exec bash -c 'generate_index "$0"' {} \;

echo "Success: English Repository UI generated with Ubuntu aesthetics."
