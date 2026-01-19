#!/usr/bin/env python3
"""Convert icon placeholders to actual Unicode characters.

Supports two placeholder formats (case-insensitive):
  {{ U+XXXX }}     - by codepoint (spaces prevent self-conversion)
  {{ nf-name }}    - by icon name

Usage: convert-placeholders.py <file>
"""

import json
import os
import re
import sys


def main():
    if len(sys.argv) < 2:
        print("Usage: convert-placeholders.py <file>", file=sys.stderr)
        sys.exit(1)

    file_path = sys.argv[1]

    if not os.path.isfile(file_path):
        print(f"File not found: {file_path}", file=sys.stderr)
        sys.exit(1)

    # Read file content
    with open(file_path, "r") as f:
        content = f.read()

    # Quick check for placeholders (case-insensitive)
    placeholder_pattern = re.compile(
        r'\{\{(u\+[0-9a-f]+|nf-[a-z0-9_-]+)\}\}', re.IGNORECASE
    )
    if not placeholder_pattern.search(content):
        sys.exit(0)

    # Load icon database
    script_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(script_dir, "..", "data", "nerdfont-icons.json")
    with open(data_path) as f:
        icons = json.load(f)

    # Build reverse lookup: name -> codepoint (lowercase keys for case-insensitive lookup)
    name_to_codepoint = {name.lower(): data["codepoint"] for name, data in icons.items()}

    def replace_placeholder(match):
        placeholder = match.group(1)

        if placeholder.upper().startswith("U+"):
            # Codepoint format
            try:
                codepoint = int(placeholder[2:], 16)
                return chr(codepoint)
            except (ValueError, OverflowError):
                return match.group(0)

        # Named format (nf-*)
        lookup_key = placeholder.lower()
        if lookup_key in name_to_codepoint:
            codepoint = int(name_to_codepoint[lookup_key], 16)
            return chr(codepoint)

        return match.group(0)

    # Replace all placeholders (case-insensitive)
    new_content = placeholder_pattern.sub(replace_placeholder, content)

    # Write back only if changed
    if new_content != content:
        with open(file_path, "w") as f:
            f.write(new_content)
        print(f"Converted placeholders in {file_path}")


if __name__ == "__main__":
    main()
