#!env python
"""
    Implementation file generator for C/C++.
    Requires python 3
"""
import pathlib
import argparse
import sys
import tempfile
import shutil
import os
from datetime import date

ROOT_DIR = pathlib.Path(__file__).parent


def die(error_msg, error_code=1):
    print("Error: {}".format(error_msg), file=sys.stderr)
    exit(error_code)


def parse_cli_args():
    parser = argparse.ArgumentParser(description="header generator tool for c/c++")
    parser.add_argument("destination_dir", type=pathlib.Path, nargs="?", default=pathlib.Path(".").resolve())
    parser.add_argument("-l", "--license", type=str, default="mit", choices={"mit", "none"}, help="Which license to preppend to the new file")
    parser.add_argument("-n", "--no-include", action="store_true", help="Do not generate a include preprocessor statement")
    parser.add_argument("-c", "--using-c", action="store_true", help="Header includes will be prefixed with .h instead of .hpp to be compatible with C")
    return parser.parse_args()


def get_replaced_lines(stream, replacements):
    """
    Go through a file stream, line by line, and fill out the template variables.
    This is a line generator.
    """
    for line in stream:
        result_line = line
        for key, value in replacements.items():
            if key in line:
                result_line = line.replace(key, str(value))
        yield result_line


def get_license_lines(replacements, license_filename, delimiter="//"):
    with (ROOT_DIR / "license_templates" / license_filename).open(mode="r") as license_file:
        yield from ("{}".format(delimiter) if len(replaced) == 0 else "{} {}".format(delimiter, replaced) for replaced in get_replaced_lines(license_file, replacements))
    yield "\n\n"


def get_build_system_templates():
    pass


def input_or_default(prompt, default=''):
    raw = input("{} [{}] ".format(prompt, default))
    return default if len(raw) == 0 else raw

def copy_files_to_output_dir(source_dir, destination_dir, replacement_parameters):
    for prefix, _, files in os.walk(source_dir):
        for temp_filename in files:
            pathprefix = pathlib.Path(prefix)

            path_input = pathprefix / temp_filename
            path_output_dir = destination_dir / pathprefix.relative_to(source_dir)
            path_output = path_output_dir / temp_filename

            if not path_output_dir.exists():
                path_output_dir.mkdir(parents=True)

            if not path_output.exists():
                with path_input.open(mode="r") as opened_input_file, path_output.open(mode="w+") as opened_output_file:
                    opened_output_file.writelines(get_replaced_lines(opened_input_file, replacement_parameters))


def main(argv):
    replacement_parameters = {
        "@@CURRENT_YEAR@@": date.today().year,
        "@@PROJECT_NAME@@": input_or_default(prompt="Project name?", default="Untitled"),
        "@@PROJECT_DESCRIPTION@@": input_or_default(prompt="Project description?")
    }

    source_dir = ROOT_DIR / "build_sys_templates"

    copy_files_to_output_dir(source_dir, argv.destination_dir, replacement_parameters)


if __name__ == "__main__":
    main(parse_cli_args())
