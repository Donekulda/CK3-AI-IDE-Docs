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


def parse_modifiers_file(file_path):
    content = try_read_file(file_path)
    lines = [line.strip() for line in content.split("\n") if line.strip()]
    modifiers = {}
    tag = None
    use_areas = None
    for line in lines:
        if line.startswith("Tag:"):
            tag = line.replace("Tag:", "").strip()
        elif line.startswith("Use areas:") and tag:
            use_areas = line.replace("Use areas:", "").strip()
            modifiers[tag] = {"use_areas": use_areas}
            tag = None
            use_areas = None
    return modifiers


def main():
    input_file = "Detailed/modifiers.log"
    output_file = "modifiers_detailed.json"
    try:
        modifiers = parse_modifiers_file(input_file)
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(modifiers, f, indent=4, ensure_ascii=False)
        print(f"Successfully converted {len(modifiers)} modifiers to JSON format")
        print(f"Output written to {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}")
        print("Please check if the input file exists and is accessible")


if __name__ == "__main__":
    main()
