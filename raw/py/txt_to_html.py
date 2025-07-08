import os
import chardet

def detect_encoding(filename):
    """Detect the encoding of a file using chardet."""
    with open(filename, 'rb') as f:
        rawdata = f.read(4096)
    result = chardet.detect(rawdata)
    encoding = result['encoding']
    if not encoding:
        encoding = 'utf-8'  # fallback
    return encoding

def txt_to_html(txt_content):
    """Convert Kannada poetic text to HTML with <p>, <br>, <h3>, <h4>, <hr>."""
    html_lines = []
    stanza = []
    for line in txt_content.splitlines():
        stripped = line.strip()
        # Section headings like || ... ||
        if stripped.startswith('||') and stripped.endswith('||'):
            if stanza:
                html_lines.append('<p>' + '<br>\n'.join(stanza) + '</p>')
                stanza = []
            html_lines.append(f'<h3>{stripped}</h3>')
        # Song/poem number headings (e.g., ೧. ...)
        elif stripped and (stripped[0].isdigit() or (stripped[0] in '೧೨೩೪೫೬೭೮೯೦')) and (stripped[1] == '.' or stripped[1] == ' '):
            if stanza:
                html_lines.append('<p>' + '<br>\n'.join(stanza) + '</p>')
                stanza = []
            html_lines.append(f'<h4>{stripped}</h4>')
        # Divider lines
        elif set(stripped) == {'_'} and len(stripped) > 2:
            if stanza:
                html_lines.append('<p>' + '<br>\n'.join(stanza) + '</p>')
                stanza = []
            html_lines.append('<hr>')
        elif stripped == '':
            if stanza:
                html_lines.append('<p>' + '<br>\n'.join(stanza) + '</p>')
                stanza = []
        else:
            stanza.append(stripped)
    if stanza:
        html_lines.append('<p>' + '<br>\n'.join(stanza) + '</p>')
    return '\n'.join(html_lines)

# Process all .txt files in the current directory
for filename in os.listdir('.'):
    if filename.lower().endswith('.txt'):
        encoding = detect_encoding(filename)
        with open(filename, 'r', encoding=encoding, errors='replace') as f:
            txt_content = f.read()
        html_content = txt_to_html(txt_content)
        html_filename = filename.rsplit('.', 1)[0] + '.html'
        with open(html_filename, 'w', encoding='utf-8') as f:
            f.write(html_content)
        print(f"Converted {filename} -> {html_filename}")

print("All files converted!")
