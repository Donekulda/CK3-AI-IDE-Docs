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


def parse_on_action_block(block):
    # Split the block into lines
    lines = [line.strip() for line in block.split("\n") if line.strip()]

    if not lines:
        return None, None

    # First line is the on_action name
    on_action_name = lines[0].strip(":")

    # Initialize the on_action dictionary
    on_action_dict = {"from_code": None, "expected_scope": None}

    # Process the remaining lines
    for line in lines[1:]:
        if line.startswith("From Code:"):
            on_action_dict["from_code"] = (
                line.replace("From Code:", "").strip() == "Yes"
            )
        elif line.startswith("Expected Scope:"):
            scope = line.replace("Expected Scope:", "").strip()
            on_action_dict["expected_scope"] = None if scope == "none" else scope

    return on_action_name, on_action_dict


def parse_on_actions_file(file_path):
    content = try_read_file(file_path)

    # Skip the first line which is "On Action Documentation:"
    blocks = content.split("--------------------")[1:]

    on_actions_dict = {}

    for block in blocks:
        if not block.strip():
            continue

        try:
            on_action_name, on_action_dict = parse_on_action_block(block.strip())
            if on_action_name and on_action_dict:
                on_actions_dict[on_action_name] = on_action_dict
        except Exception as e:
            print(f"Error processing block: {block[:100]}...")
            print(f"Error: {str(e)}")

    return on_actions_dict


def main():
    input_file = "Detailed/on_actions.log"
    output_file = "on_actions_detailed.json"

    try:
        on_actions_dict = parse_on_actions_file(input_file)

        # Write the JSON with proper formatting
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(on_actions_dict, f, indent=4, ensure_ascii=False)

        print(
            f"Successfully converted {len(on_actions_dict)} on_actions to JSON format"
        )
        print(f"Output written to {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}")
        print("Please check if the input file exists and is accessible")


if __name__ == "__main__":
    main()
