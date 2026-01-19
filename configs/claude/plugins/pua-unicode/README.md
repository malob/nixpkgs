# pua-unicode

Workaround for Claude Code filtering BMP Private Use Area Unicode characters (U+E000-U+F8FF). Nerd Font icons are the primary use case, but this applies to any PUA characters in this range.

## Problem

Claude Code strips characters in the BMP PUA range before tools receive them. This makes it impossible to directly write icons from sets like Powerline, Devicons, Font Awesome, and Octicons.

Characters in the Supplementary PUA-A range (U+F0000+), like Material Design Icons, work fine.

## Solution

This plugin provides:

1. **Placeholder syntax** - Write `{{U+E0A0}}` or `{{nf-fa-star}}` instead of literal icons
2. **Automatic conversion** - PostToolUse hook converts placeholders after file writes
3. **Automatic identification** - PostToolUse hook identifies icons when reading files
4. **Icon lookup** - `/icon-lookup` command to search for icons by name

## Usage

### Writing Icons

Use placeholder syntax for icons in the filtered BMP PUA range:

```nix
# By codepoint
git_branch.symbol = "{{U+E0A0}} ";

# By name
git_branch.symbol = "{{nf-dev-git_branch}} ";
```

The hook automatically converts placeholders after the file is saved.

### Reading Files with Icons

When Claude reads a file containing PUA characters, a hook automatically identifies them:

```
[Icons: 61 known + 12 unknown PUA, 73 total]
  L7: 󰁹 = nf-md-battery (U+F0079)
  L14: nf-fa-aws (U+F0EF) (filtered)
  ...
```

### Looking Up Icons

Use the `/icon-lookup` command:

```
/icon-lookup git branch
/icon-lookup folder
/icon-lookup star
```

### Identifying Characters

Identify a specific character directly:

```bash
# Direct argument
scripts/identify-icons.py -c "󰁹"

# From stdin
echo "󰁹" | scripts/identify-icons.py -

# From file
scripts/identify-icons.py /path/to/file
```

### Manual Conversion

Run the conversion script directly:

```bash
scripts/convert-placeholders.py /path/to/file
```

## Components

- `commands/icon-lookup.md` - Icon lookup command
- `skills/icon-lookup/SKILL.md` - Skill for proactive icon handling
- `hooks/hooks.json` - PostToolUse hooks for conversion and identification
- `scripts/convert-placeholders.py` - Placeholder to Unicode conversion
- `scripts/lookup-icon.py` - Search icons by name
- `scripts/identify-icons.py` - Identify icons in files or strings
- `data/nerdfont-icons.json` - Icon database (sourced from Nerd Fonts)

## Related

- [GitHub Issue #9907](https://github.com/anthropics/claude-code/issues/9907) - The underlying bug report
