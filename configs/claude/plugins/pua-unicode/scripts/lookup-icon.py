#!/usr/bin/env python3
"""Search for icons by name or keyword using the Nerd Fonts database."""

import json
import os
import sys

def load_icons():
    """Load the nerdfont-icons.json database."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(script_dir, "..", "data", "nerdfont-icons.json")
    with open(data_path, "r") as f:
        return json.load(f)

def is_bmp_pua(codepoint_hex):
    """Check if codepoint is in the filtered BMP PUA range (U+E000-U+F8FF)."""
    cp = int(codepoint_hex, 16)
    return 0xE000 <= cp <= 0xF8FF

def search_icons(query, icons, limit=10):
    """Search icons by name, returning matches."""
    query_lower = query.lower()
    terms = query_lower.split()

    matches = []
    for name, data in icons.items():
        name_lower = name.lower()
        # All terms must appear in the name
        if all(term in name_lower for term in terms):
            matches.append((name, data))

    # Sort by name length (prefer shorter/more specific matches)
    matches.sort(key=lambda x: len(x[0]))
    return matches[:limit]

def format_result(name, data):
    """Format a single icon result."""
    codepoint = data.get("codepoint", "unknown")
    icon = data.get("icon", "")

    cp_upper = codepoint.upper()
    in_bmp_pua = is_bmp_pua(codepoint)

    status = "FILTERED (use placeholder)" if in_bmp_pua else "WORKS (can write directly)"

    lines = [
        f"Name: {name}",
        f"Character: {icon}",
        f"Codepoint: U+{cp_upper}",
        f"Status: {status}",
    ]

    if in_bmp_pua:
        lines.append(f"Placeholder: {{{{U+{cp_upper}}}}} or {{{{{name}}}}}")

    return "\n".join(lines)

def main():
    if len(sys.argv) < 2:
        print("Usage: lookup-icon.py <search query>")
        print("Example: lookup-icon.py git branch")
        sys.exit(1)

    query = " ".join(sys.argv[1:])
    icons = load_icons()
    matches = search_icons(query, icons)

    if not matches:
        print(f"No icons found matching '{query}'")
        print("Try different search terms or browse: https://www.nerdfonts.com/cheat-sheet")
        sys.exit(0)

    print(f"Found {len(matches)} icon(s) matching '{query}':\n")

    for i, (name, data) in enumerate(matches):
        if i > 0:
            print("\n" + "-" * 40 + "\n")
        print(format_result(name, data))

if __name__ == "__main__":
    main()
