---
description: Search for icons by name, or identify a PUA character
argument-hint: "<search query or character>"
allowed-tools: ["Bash", "Read"]
---

# Icon Lookup

Search for icons by name or identify an actual PUA character. Uses the Nerd Fonts icon database.

## Instructions

**If the argument contains PUA characters** (codepoints in U+E000-U+F8FF or U+F0000+), identify them:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/identify-icons.py -c "$ARGUMENTS"
```

**Otherwise**, search by name:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/lookup-icon.py "$ARGUMENTS"
```

Present results showing:
- Icon name (e.g., `nf-fa-star`)
- Codepoint (e.g., `U+F005`)
- Whether it's in the filtered BMP PUA range (U+E000-U+F8FF) or the working Supplementary PUA-A range (U+F0000+)
- For filtered icons: placeholder syntax `{{U+F005}}` or `{{nf-fa-star}}`
- For working icons: note they can be written directly

If no results found, suggest different search terms or the Nerd Fonts cheat sheet.

## Examples

- `/icon-lookup git` → search for git-related icons
- `/icon-lookup 󰊤` → identify the character (nf-md-github)
