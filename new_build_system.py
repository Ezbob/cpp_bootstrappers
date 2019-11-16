#!env python
"""
    Implementation file generator for C/C++.
    Requires python 3
"""
import pathlib
import argparse
import sys
import os
from datetime import date

ROOT_DIR = pathlib.Path(__file__).parent


def die(error_msg, error_code=1):
    print("Error: {}".format(error_msg), file=sys.stderr)
    exit(error_code)


def parse_cli_args():
    parser = argparse.ArgumentParser(description="Build system bootstrapper for c/c++")
    parser.add_argument("destination_dir", type=pathlib.Path, nargs="?", default=pathlib.Path(".").resolve())

    parameter_parameter_group = parser.add_argument_group(
        title="Parameter arguments", 
        description="Replacement parameters used in template files"
    )

    parameter_parameter_group.add_argument('--author', type=str, default=None)
    parameter_parameter_group.add_argument('--current-year', type=int, default=int(date.today().year))
    parameter_parameter_group.add_argument('--project-name', type=str, default=None)
    parameter_parameter_group.add_argument('--project-description', type=str, default=None)


    return parser.parse_args()


def get_replaced_lines(stream, replacements):
    """
    Go through a file stream, line by line, and fill out the template variables.
    This is a line generator.
    """
    for line in stream:
        result_line = line
        for key, value in replacements.items():
            if key in result_line:
                result_line = result_line.replace(key, str(value))
        yield result_line


def get_license_lines(replacements, license_filename, delimiter="//"):
    with (ROOT_DIR / "license_templates" / license_filename).open(mode="r") as license_file:
        yield from ("{}".format(delimiter) if len(replaced) == 0 else "{} {}".format(delimiter, replaced) for replaced in get_replaced_lines(license_file, replacements))
    yield "\n\n"


def input_or_default(prompt, default=''):
    raw = input("{} [{}] ".format(prompt, default))
    return default if len(raw) == 0 else raw


def copy_files_to_output_dir(source_dir, destination_dir, replacement_parameters):
    for prefix, _, files in os.walk(source_dir):
        pathprefix = pathlib.Path(prefix)
        for temp_filename in files:

            path_input = pathprefix / temp_filename
            path_output_dir = destination_dir / pathprefix.relative_to(source_dir)
            path_output = path_output_dir / temp_filename

            if not path_output_dir.exists():
                path_output_dir.mkdir(parents=True)

            if not path_output.exists():
                with path_input.open(mode="r") as opened_input_file, path_output.open(mode="w+") as opened_output_file:
                    opened_output_file.writelines(get_replaced_lines(opened_input_file, replacement_parameters))


def get_parameters(argv):

    def not_none(val):
        return val is not None

    def not_none_and_not_empty(val):
        return val is not None and len(val) > 0

    author = argv.author if not_none(argv.author) else input_or_default(prompt="Author?", default="Anders Busch")
    project_name = argv.project_name if not_none_and_not_empty(argv.project_name) else input_or_default(prompt="Project name?", default="Untitled")
    project_description = argv.project_description if not_none(argv.project_description) else input_or_default(prompt="Project description?")

    return {
        "@@CURRENT_YEAR@@": argv.current_year,
        "@@AUTHOR_NAME@@": author,
        "@@PROJECT_NAME@@": project_name,
        "@@PROJECT_DESCRIPTION@@": project_description
    }

def main(argv):
    replacement_parameters = get_parameters(argv)

    source_dir = ROOT_DIR / "build_sys_templates"

    copy_files_to_output_dir(source_dir, argv.destination_dir, replacement_parameters)


if __name__ == "__main__":
    main(parse_cli_args())
