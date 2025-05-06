import json
import codecs


def try_read_file(file_path):
    encodings = [
        "utf-8",
        "cp1252",
        "iso-8859-1",
        "ascii",
        "latin1",
    ]
    content = None
    for encoding in encodings:
        try:
            with codecs.open(file_path, "r", encoding=encoding) as f:
                content = f.read()
                print(f"Successfully read file with {encoding} encoding")
                return content
        except UnicodeDecodeError:
            continue
    if content is None:
        raise ValueError(
            f"Could not read file with any of the attempted encodings: {encodings}"
        )
    return content


def parse_event_scopes_file(file_path):
    content = try_read_file(file_path)
    lines = [line.strip() for line in content.split("\n") if line.strip()]
    scopes = {}
    current_scope = None
    current_props = {}
    for line in lines:
        if line.endswith(":") and not line.startswith("Save Token"):
            if current_scope and current_props:
                scopes[current_scope] = current_props
            current_scope = line[:-1]
            current_props = {}
        elif ":" in line and current_scope:
            key, value = line.split(":", 1)
            current_props[key.strip()] = value.strip()
    if current_scope and current_props:
        scopes[current_scope] = current_props
    return scopes


def main():
    input_file = "Detailed/event_scopes.log"
    output_file = "event_scopes_detailed.json"
    try:
        scopes = parse_event_scopes_file(input_file)
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(scopes, f, indent=4, ensure_ascii=False)
        print(f"Successfully converted {len(scopes)} event scopes to JSON format")
        print(f"Output written to {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}")
        print("Please check if the input file exists and is accessible")


if __name__ == "__main__":
    main()
