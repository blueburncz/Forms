#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import jsbeautifier
import os
import re
import subprocess
import sys

OPTIONS = {
    "indent_size": 4,
    "indent_char": " ",
    "indent_with_tabs": True,
    "editorconfig": False,
    "eol": "\n",
    "end_with_newline": True,
    "indent_level": 0,
    "preserve_newlines": True,
    "max_preserve_newlines": 2,
    "space_in_paren": False,
    "space_in_empty_paren": False,
    "jslint_happy": False,
    "space_after_anon_function": True,
    "space_after_named_function": False,
    "brace_style": "expand,preserve-inline",
    "unindent_chained_methods": False,
    "break_chained_methods": False,
    "keep_array_indentation": False,
    "unescape_strings": False,
    "wrap_line_length": 120,
    "e4x": True,
    "comma_first": False,
    "operator_position": "before-newline",
    "indent_empty_lines": False,
    "templating": ["auto"],
}


def beautify_file(filepath):
    res = jsbeautifier.beautify_file(filepath, OPTIONS)
    res = re.sub(r"\$[ \n]+\"", '$"', res)
    return res


def get_staged_files():
    # Run the git command
    result = subprocess.run(
        ["git", "diff", "--name-only", "--cached"],
        stdout=subprocess.PIPE,  # Capture output
        stderr=subprocess.PIPE,  # Capture errors
        text=True,
    )  # Return output as string

    # Check if there was an error
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
        return []

    # Get the output (list of file paths)
    staged_files = result.stdout.strip().split("\n")

    # Remove any empty strings (in case no files are staged)
    return [file for file in staged_files if file]


def get_staged_file_contents(file_path):
    try:
        # Run the git show command to get the staged contents
        result = subprocess.run(
            ["git", "show", f":{file_path}"], capture_output=True, text=True, check=True
        )
        return result.stdout  # Return the staged file contents
    except subprocess.CalledProcessError as e:
        print(f"ERROR: {e}")
        exit(1)


if __name__ == "__main__":
    target = "--staged"
    filepath = None

    if len(sys.argv) > 1:
        target = sys.argv[1]

    if target == "--file":
        if len(sys.argv) > 2:
            filepath = sys.argv[2]
        else:
            print("Argument FILE not defined!")
            print(1)

    if target == "--validate":
        for filepath in get_staged_files():
            if filepath.endswith(".gml"):
                orig = get_staged_file_contents(filepath)
                res = beautify_file(filepath)
                if orig != res:
                    print(
                        f'ERROR: File "{filepath}" is not properly formatted!\n\nPlease run ./format-gml.py to fix formatting of all staged GML files and stage the changes before running commit again.'
                    )
                    exit(1)
    elif target == "--staged":
        for filepath in get_staged_files():
            if filepath.endswith(".gml"):
                res = beautify_file(filepath)
                with open(filepath, "w") as f:
                    f.write(res)
    elif target == "--all":
        for dirpath, _, filenames in os.walk("."):
            for filename in filenames:
                if filename.endswith(".gml"):
                    filepath = os.path.join(dirpath, filename)
                    res = beautify_file(filepath)
                    with open(filepath, "w") as f:
                        f.write(res)
    elif target == "--file":
        res = beautify_file(filepath)
        with open(filepath, "w") as f:
            f.write(res)
    else:
        print(f"Invalid target {target}!")
        exit(1)
