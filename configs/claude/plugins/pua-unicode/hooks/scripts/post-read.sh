#!/usr/bin/env bash
# PostToolUse hook: Identify PUA Unicode characters after Read operations.
#
# When Claude reads a file containing PUA characters, this hook identifies
# them by name and codepoint so Claude knows what icons are present.
#
# Outputs JSON with additionalContext so Claude sees the icon info in context.

set -euo pipefail

# Extract file path from stdin JSON
FILE_PATH=$(jq -r '.tool_input.file_path // empty')

# Skip if no file path or file doesn't exist
if [[ -z "$FILE_PATH" ]] || [[ ! -f "$FILE_PATH" ]]; then
    exit 0
fi

# Skip non-text files
MIME=$(file --brief --mime-type "$FILE_PATH" 2>/dev/null)
if [[ "$MIME" != text/* ]]; then
    exit 0
fi

# Run the identification script and capture output
ICON_INFO=$(python3 "$CLAUDE_PLUGIN_ROOT/scripts/identify-icons.py" "$FILE_PATH" 2>/dev/null || true)

# If icons were found, output JSON for Claude
if [[ -n "$ICON_INFO" ]]; then
    # JSON for Claude (injected into context)
    # Imperative reminder to load the skill
    CONTEXT="PUA codepoints detected. Ensure icon-lookup skill is loaded.

$ICON_INFO"
    ESCAPED=$(echo "$CONTEXT" | jq -Rs .)
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": $ESCAPED
  }
}
EOF
fi

exit 0
