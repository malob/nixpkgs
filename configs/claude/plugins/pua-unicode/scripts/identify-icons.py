#!/usr/bin/env python3
"""Identify PUA Unicode characters in a file using the Nerd Fonts database."""

import json
import os
import sys
from collections import defaultdict


def load_icons():
    """Load the nerdfont-icons.json database and create reverse lookup."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(script_dir, "..", "data", "nerdfont-icons.json")
    with open(data_path, "r") as f:
        icons = json.load(f)

    # Create reverse lookup: codepoint -> name
    reverse = {}
    for name, data in icons.items():
        cp = int(data["codepoint"], 16)
        reverse[cp] = name
    return reverse


def is_pua(codepoint):
    """Check if codepoint is in any Private Use Area range."""
    # BMP PUA: U+E000-U+F8FF
    # Supplementary PUA-A: U+F0000-U+FFFFF
    # Supplementary PUA-B: U+100000-U+10FFFF
    return (0xE000 <= codepoint <= 0xF8FF or
            0xF0000 <= codepoint <= 0xFFFFF or
            0x100000 <= codepoint <= 0x10FFFF)


def is_bmp_pua(codepoint):
    """Check if codepoint is in the filtered BMP PUA range."""
    return 0xE000 <= codepoint <= 0xF8FF


def identify_icons(file_path, reverse_lookup):
    """Find and identify all PUA characters in a file."""
    with open(file_path, "r", encoding="utf-8", errors="replace") as f:
        lines = f.readlines()

    findings = []  # List of (line_num, char, codepoint, name, is_filtered, is_known)

    for line_num, line in enumerate(lines, start=1):
        for char in line:
            cp = ord(char)
            if is_pua(cp):
                name = reverse_lookup.get(cp)
                is_known = name is not None
                if not is_known:
                    name = "unknown PUA"
                filtered = is_bmp_pua(cp)
                findings.append((line_num, char, cp, name, filtered, is_known))

    return findings


def format_output(findings):
    """Format findings for output."""
    if not findings:
        return ""

    # Group by icon for compact output
    icon_info = defaultdict(lambda: {"lines": [], "filtered": False, "known": True})
    for line_num, char, cp, name, filtered, is_known in findings:
        key = (cp, name, char)
        icon_info[key]["lines"].append(line_num)
        icon_info[key]["filtered"] = filtered
        icon_info[key]["known"] = is_known

    # Count known vs unknown
    known_count = sum(1 for info in icon_info.values() if info["known"])
    unknown_count = len(icon_info) - known_count

    # Build header
    header_parts = []
    if known_count:
        header_parts.append(f"{known_count} known")
    if unknown_count:
        header_parts.append(f"{unknown_count} unknown PUA")
    header = f"[Icons: {' + '.join(header_parts)}, {len(findings)} total]"

    lines = [header]

    for (cp, name, char), info in sorted(icon_info.items(), key=lambda x: min(x[1]["lines"])):
        cp_str = f"U+{cp:04X}" if cp <= 0xFFFF else f"U+{cp:05X}"
        line_refs = ", ".join(str(ln) for ln in sorted(set(info["lines"]))[:5])
        if len(info["lines"]) > 5:
            line_refs += f" +{len(info['lines']) - 5} more"

        status = " (filtered)" if info["filtered"] else ""
        if info["known"]:
            lines.append(f"  L{line_refs}: {char} = {name} ({cp_str}){status}")
        else:
            lines.append(f"  L{line_refs}: {char} = unknown PUA ({cp_str}){status}")

    return "\n".join(lines)


def identify_string(text, reverse_lookup):
    """Find and identify all PUA characters in a string."""
    findings = []
    for i, char in enumerate(text):
        cp = ord(char)
        if is_pua(cp):
            name = reverse_lookup.get(cp)
            is_known = name is not None
            if not is_known:
                name = "unknown PUA"
            filtered = is_bmp_pua(cp)
            # Use position instead of line number for string mode
            findings.append((i + 1, char, cp, name, filtered, is_known))
    return findings


def format_single(char, reverse_lookup):
    """Format info for a single character."""
    cp = ord(char)
    if not is_pua(cp):
        return f"'{char}' (U+{cp:04X}) is not a PUA character"

    name = reverse_lookup.get(cp)
    filtered = is_bmp_pua(cp)
    cp_str = f"U+{cp:04X}" if cp <= 0xFFFF else f"U+{cp:05X}"

    status = " (filtered)" if filtered else ""
    if name:
        return f"{char} = {name} ({cp_str}){status}"
    else:
        return f"{char} = unknown PUA ({cp_str}){status}"


def main():
    if len(sys.argv) < 2:
        print("Usage: identify-icons.py <file_path>", file=sys.stderr)
        print("       identify-icons.py -c <character(s)>", file=sys.stderr)
        print("       echo '󰁹' | identify-icons.py -", file=sys.stderr)
        sys.exit(1)

    try:
        reverse_lookup = load_icons()

        if sys.argv[1] == "-c":
            # Direct character mode: identify-icons.py -c "󰁹"
            if len(sys.argv) < 3:
                print("Error: -c requires a character argument", file=sys.stderr)
                sys.exit(1)
            text = sys.argv[2]
            for char in text:
                print(format_single(char, reverse_lookup))

        elif sys.argv[1] == "-":
            # Stdin mode: echo "󰁹" | identify-icons.py -
            text = sys.stdin.read().strip()
            for char in text:
                if is_pua(ord(char)):
                    print(format_single(char, reverse_lookup))

        else:
            # File mode (original behavior)
            file_path = sys.argv[1]
            if not os.path.isfile(file_path):
                sys.exit(0)
            findings = identify_icons(file_path, reverse_lookup)
            output = format_output(findings)
            if output:
                print(output)

    except Exception as e:
        # In interactive modes (-c, -), show errors; in file mode, fail silently
        # to avoid interrupting the read operation
        if len(sys.argv) > 1 and sys.argv[1] in ["-c", "-"]:
            print(f"Error: {e}", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    main()
