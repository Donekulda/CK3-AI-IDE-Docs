import json
import codecs
import re


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


def parse_event_targets_file(file_path):
    content = try_read_file(file_path)
    blocks = content.split("--------------------")
    event_targets = {}
    for block in blocks:
        lines = [line.strip() for line in block.split("\n") if line.strip()]
        if not lines:
            continue
        # First line: name and description
        if " - " in lines[0]:
            name, desc = lines[0].split(" - ", 1)
        else:
            name = lines[0]
            desc = ""
        name = name.strip()
        desc = desc.strip()
        props = {"desc": desc}
        for line in lines[1:]:
            if ":" in line:
                key, value = line.split(":", 1)
                props[key.strip().replace(" ", "_").lower()] = value.strip()
        event_targets[name] = props
    return event_targets


def main():
    input_file = "Detailed/event_targets.log"
    output_file = "event_targets_detailed.json"
    try:
        event_targets = parse_event_targets_file(input_file)
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(event_targets, f, indent=4, ensure_ascii=False)
        print(
            f"Successfully converted {len(event_targets)} event targets to JSON format"
        )
        print(f"Output written to {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}")
        print("Please check if the input file exists and is accessible")


if __name__ == "__main__":
    main()
