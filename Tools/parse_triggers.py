import json
import re
import codecs


def try_read_file(file_path):
    # List of encodings to try
    encodings = [
        "utf-8",
        "cp1252",  # Windows-1252
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


def parse_trigger_block(block):
    # Split the block into lines
    lines = [line.strip() for line in block.split("\n") if line.strip()]

    if not lines:
        return None, None

    # First line contains the trigger name and description
    first_line = lines[0]
    if " - " in first_line:
        trigger_name, desc = first_line.split(" - ", 1)
    else:
        trigger_name = first_line
        desc = ""

    trigger_name = trigger_name.strip()

    # Initialize the trigger dictionary
    trigger_dict = {
        "desc": desc.strip(),
        "usage": [],
        "traits": None,
        "supported_scopes": None,
        "supported_targets": None,
    }

    # Process the remaining lines
    usage_lines = []
    in_usage = False

    for line in lines[1:]:
        if line.startswith("Traits:"):
            trigger_dict["traits"] = line.replace("Traits:", "").strip()
            in_usage = False
        elif line.startswith("Supported Scopes:"):
            trigger_dict["supported_scopes"] = line.replace(
                "Supported Scopes:", ""
            ).strip()
            in_usage = False
        elif line.startswith("Supported Targets:"):
            trigger_dict["supported_targets"] = line.replace(
                "Supported Targets:", ""
            ).strip()
            in_usage = False
        # If line contains typical syntax elements, it's likely usage
        elif any(x in line for x in ["=", "{", "}", "<", ">", "/"]) or in_usage:
            in_usage = True
            usage_lines.append(line)

    # Join usage lines if we have any
    if usage_lines:
        trigger_dict["usage"] = usage_lines

    return trigger_name, trigger_dict


def parse_triggers_file(file_path):
    content = try_read_file(file_path)

    # Skip the first line which is "Trigger Documentation:"
    blocks = content.split("--------------------")[1:]

    triggers_dict = {}

    for block in blocks:
        if not block.strip():
            continue

        try:
            trigger_name, trigger_dict = parse_trigger_block(block.strip())
            if trigger_name and trigger_dict:
                triggers_dict[trigger_name] = trigger_dict
        except Exception as e:
            print(f"Error processing block: {block[:100]}...")
            print(f"Error: {str(e)}")

    return triggers_dict


def main():
    input_file = "Detailed/triggers.log"
    output_file = "triggers_detailed.json"

    try:
        triggers_dict = parse_triggers_file(input_file)

        # Write the JSON with proper formatting
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(triggers_dict, f, indent=4, ensure_ascii=False)

        print(f"Successfully converted {len(triggers_dict)} triggers to JSON format")
        print(f"Output written to {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}")
        print("Please check if the input file exists and is accessible")


if __name__ == "__main__":
    main()
