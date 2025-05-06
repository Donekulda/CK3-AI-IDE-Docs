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


def parse_effect_block(block):
    # Split the first line to get the effect name and description
    first_line = block[0].strip()
    if " - " in first_line:
        effect_name, desc = first_line.split(" - ", 1)
    else:
        effect_name = first_line
        desc = ""

    effect_name = effect_name.strip()

    # Initialize the effect dictionary
    effect_dict = {
        "desc": desc.strip(),
        "usage": "",
        "supported_scopes": "",
        "supported_targets": None,
        "notes": None,
    }

    # Process the remaining lines
    usage_lines = []
    notes = []
    in_usage = False

    for line in block[1:]:
        line = line.strip()
        if not line:
            continue

        if line.startswith("Supported Scopes:"):
            effect_dict["supported_scopes"] = line.replace(
                "Supported Scopes:", ""
            ).strip()
            in_usage = False
        elif line.startswith("Supported Targets:"):
            effect_dict["supported_targets"] = line.replace(
                "Supported Targets:", ""
            ).strip()
            in_usage = False
        # If line contains an equals sign or starts with common syntax elements, it's likely usage
        elif "=" in line or line.startswith(
            ("limit", "order_by", "position", "min", "max", "<effects>")
        ):
            in_usage = True
            usage_lines.append(line)
        # If we're not in usage section and it's not a special line, it might be a note
        elif not in_usage and not line.startswith(("Supported", "----")):
            notes.append(line)

    # Join usage lines
    if usage_lines:
        effect_dict["usage"] = "\n".join(usage_lines)

    # Join notes if we have any
    if notes:
        effect_dict["notes"] = " ".join(notes)

    return effect_name, effect_dict


def parse_effects_file(file_path):
    content = try_read_file(file_path)

    # Skip the first line which is "Effect Documentation:"
    blocks = content.split("--------------------")[1:]

    effects_dict = {}

    for block in blocks:
        if not block.strip():
            continue

        lines = [line for line in block.split("\n") if line.strip()]
        if not lines:
            continue

        try:
            effect_name, effect_dict = parse_effect_block(lines)
            effects_dict[effect_name] = effect_dict
        except Exception as e:
            print(f"Error processing block: {lines[:2]}")
            print(f"Error: {str(e)}")

    return effects_dict


def main():
    input_file = "Detailed/effects.log"
    output_file = "effects_detailed.json"

    try:
        effects_dict = parse_effects_file(input_file)

        # Write the JSON with proper formatting
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(effects_dict, f, indent=4, ensure_ascii=False)

        print(f"Successfully converted {len(effects_dict)} effects to JSON format")
        print(f"Output written to {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}")
        print("Please check if the input file exists and is accessible")


if __name__ == "__main__":
    main()
