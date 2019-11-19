#!env python
"""
    Header file generator for C/C++.
    Requires python 3
"""
import pathlib
import argparse
import uuid
import sys
from datetime import date

ROOT_DIR = pathlib.Path(__file__).parent


def die(error_msg, error_code=1):
    print("Error: {}".format(error_msg), file=sys.stderr)
    exit(error_code)


def parse_cli_args():
    parser = argparse.ArgumentParser(description="header generator tool for c/c++")
    parser.add_argument("new_filepath", type=pathlib.Path)
    parser.add_argument("-l", "--license", type=str, default="mit", choices={"mit", "none"})
    parser.add_argument("-a", "--author", type=str, default="Anders Busch")
    return parser.parse_args()


def get_replaced_lines(stream, replacements, delimiter="//"):
    """
    Go through a file stream, line by line, and fill out the template variables.
    This is a line generator.
    """
    for line in stream:
        result_line = line
        for key, value in replacements.items():
            if key in line:
                result_line = result_line.replace(key, str(value))
        if len(result_line.strip()) == 0:
            yield "{}\n".format(delimiter)
        else:
            yield "{} {}".format(delimiter, result_line)


def get_license_lines(replacements, license_filename, delimiter="//"):
    with (ROOT_DIR / "license_templates" / license_filename).open(mode="r") as license_file:
        yield from get_replaced_lines(license_file, replacements, delimiter)
    yield "\n\n"


def main(argv):
    if argv.new_filepath.exists(): die("File already exists. Stopping")

    replacement_parameters = {
        "@@CURRENT_YEAR@@": date.today().year,
        "@@AUTHOR_NAME@@": argv.author
    }

    with argv.new_filepath.open(mode="w+") as out_file:
        if argv.license != "none":
            out_file.writelines(get_license_lines(replacements=replacement_parameters, license_filename=argv.license))

        header_symbol = "_HEADER_GUARD_{}".format(uuid.uuid4().hex)

        out_file.writelines([
            "#ifndef {}\n".format(header_symbol),
            "#define {}\n".format(header_symbol),
            "\n",
            "// add your code here\n",
            "\n",
            "#endif\n"
        ])

if __name__ == "__main__":
    main(parse_cli_args())
