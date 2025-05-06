import subprocess
import sys
import os


def run_parser(script_name):
    print(f"Running {script_name}...")
    result = subprocess.run(
        [sys.executable, script_name], cwd=os.path.dirname(__file__)
    )
    if result.returncode == 0:
        print(f"{script_name} completed successfully.\n")
    else:
        print(f"{script_name} failed with return code {result.returncode}.\n")
        sys.exit(result.returncode)


def main():
    scripts = [
        "parse_triggers.py",
        "parse_on_actions.py",
        "parse_effects.py",
    ]
    for script in scripts:
        run_parser(script)
    print("All parsers completed.")


if __name__ == "__main__":
    main()
