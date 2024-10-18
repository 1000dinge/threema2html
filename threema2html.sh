#!/bin/bash

# Überprüfen, ob eine Datei als Parameter übergeben wurde
if [ "$#" -ne 1 ]; then
    echo "Verwendung: $0 <dateiname>"
    exit 1
fi

# Datei-Variable
input_file="$1"

# Überprüfen, ob die Datei existiert
if [ ! -f "$input_file" ]; then
    echo "Datei '$input_file' nicht gefunden!"
    exit 1
fi

# HTML-Kopfteil
cat << 'EOF'
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat im WhatsApp-Stil</title>
    <style>
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #e5ddd5;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed; /* Gleichmäßige Spaltenbreite */
        }
        td {
            padding: 10px;
            vertical-align: top;
            width: 50%; /* Beide Spalten gleich breit */
        }
        .left {
            text-align: left;
            background-color: #dcf8c6;
            color: black;
            border-radius: 10px;
            padding: 10px;
        }
        .right {
            text-align: right;
            background-color: #fff;
            color: black;
            border-radius: 10px;
            padding: 10px;
        }
        img, video {
            max-width: 400px;  /* Verdoppelte Größe für Bilder und Videos */
            height: auto;
            display: block;
            margin-top: 5px;
            border-radius: 10px;
        }
        .timestamp {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        a.file-link {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }
        .caption {
            font-size: 14px;
            color: #555;
            margin-top: 5px;
        }
    </style>
</head>
<body>

    <table>
EOF

# Durch die Zeilen der Datei iterieren und das passende HTML-Format anwenden
while IFS= read -r line; do
    timestamp=$(echo "$line" | grep -oP '\d{2}:\d{2}')
    
    if [[ "$line" == "<<<"* ]]; then
        content=$(echo "$line" | sed -e 's/<<< //')
        
        # Untertitel erkennen, falls vorhanden
        if [[ "$content" == *" Untertitel "* ]]; then
            caption=$(echo "$content" | grep -oP 'Untertitel .*' | cut -d':' -f2 | sed 's/^ *//')
            content=$(echo "$content" | sed -e 's/ Untertitel .*//')
        else
            caption=""
        fi
        
        # Bild-Datei erkennen
        if [[ "$content" == *"Bild ("* ]]; then
            img_src=$(echo "$content" | grep -oP '\((.*?)\)' | tr -d '()')
            echo "        <tr><td class=\"left\"><a href=\"$img_src\" target=\"_blank\"><img src=\"$img_src\" alt=\"Bild\"></a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td><td></td></tr>"
        
        # Video-Datei erkennen
        elif [[ "$content" == *"Video ("* ]]; then
            video_src=$(echo "$content" | grep -oP '\((.*?)\)' | tr -d '()')
            echo "        <tr><td class=\"left\"><a href=\"$video_src\" target=\"_blank\"><video controls src=\"$video_src\"></video></a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td><td></td></tr>"
        
        # Datei-Link erkennen
        elif [[ "$content" == *"Datei:"* ]]; then
            #file_name=$(echo "$content" | cut -d' ' -f2)
	    file_name=$(echo "$content" | grep -oP 'Datei: .*' | cut -d':' -f2 | sed 's/^ *//' | tr -d '\r\n')
	    echo "        <!-- content  = ($content) -->"
	    echo "        <!-- filename = ($file_name) -->"
            # Überprüfen, ob die Datei auf .jpg oder .jpeg endet, und es als Bild ausgeben
            if [[ "$file_name" == *.jpg || "$file_name" == *.jpeg ]]; then
                echo "        <tr><td class=\"left\"><a href=\"$file_name\" target=\"_blank\"><img src=\"$file_name\" alt=\"Bild\"></a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td><td></td></tr>"
            else
                echo "        <tr><td class=\"left\"><a href=\"$file_name\" class=\"file-link\" target=\"_blank\">Datei: $file_name</a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td><td></td></tr>"
            fi
        
        # Anderer Inhalt
        else
            echo "        <tr><td class=\"left\">$content<div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td><td></td></tr>"
        fi
    
    elif [[ "$line" == ">>>"* ]]; then
        content=$(echo "$line" | sed -e 's/>>> //')
        
        # Untertitel erkennen, falls vorhanden
        if [[ "$content" == *" Untertitel "* ]]; then
            caption=$(echo "$content" | grep -oP 'Untertitel .*' | cut -d':' -f2 | sed 's/^ *//')
            content=$(echo "$content" | sed -e 's/ Untertitel .*//')
        else
            caption=""
        fi
        
        # Bild-Datei erkennen
        if [[ "$content" == *"Bild ("* ]]; then
            img_src=$(echo "$content" | grep -oP '\((.*?)\)' | tr -d '()')
            echo "        <tr><td></td><td class=\"right\"><a href=\"$img_src\" target=\"_blank\"><img src=\"$img_src\" alt=\"Bild\"></a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td></tr>"
        
        # Video-Datei erkennen
        elif [[ "$content" == *"Video ("* ]]; then
            video_src=$(echo "$content" | grep -oP '\((.*?)\)' | tr -d '()')
            echo "        <tr><td></td><td class=\"right\"><a href=\"$video_src\" target=\"_blank\"><video controls src=\"$video_src\"></video></a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td></tr>"
        
        # Datei-Link erkennen
        elif [[ "$content" == *"Datei:"* ]]; then
            #file_name=$(echo "$content" | cut -d' ' -f2)
            file_name=$(echo "$content" | grep -oP 'Datei: .*' | cut -d':' -f2 | sed 's/^ *//' | tr -d '\r\n')
	    echo "        <!-- content  = ($content) -->"
	    echo "        <!-- filename = ($file_name) -->"
            # Überprüfen, ob die Datei auf .jpg oder .jpeg endet, und es als Bild ausgeben
            if [[ "$file_name" == *.jpg || "$file_name" == *.jpeg ]]; then
                echo "        <tr><td></td><td class=\"right\"><a href=\"$file_name\" target=\"_blank\"><img src=\"$file_name\" alt=\"Bild\"></a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td></tr>"
            else
                echo "        <tr><td></td><td class=\"right\"><a href=\"$file_name\" class=\"file-link\" target=\"_blank\">Datei: $file_name</a><div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td></tr>"
            fi
        
        # Anderer Inhalt
        else
            echo "        <tr><td></td><td class=\"right\">$content<div class=\"timestamp\">$timestamp</div><div class=\"caption\">$caption</div></td></tr>"
        fi
    fi
done < "$input_file"

# HTML-Fußteil
cat << 'EOF'
    </table>

</body>
</html>
EOF

