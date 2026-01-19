#!/usr/bin/env bash
# PostToolUse hook: Convert icon placeholders after Edit/Write operations.
#
# Outputs JSON with additionalContext so Claude sees the conversion info in context.

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

# Run the conversion script and capture output
CONVERT_OUTPUT=$("${CLAUDE_PLUGIN_ROOT}/scripts/convert-placeholders.py" "$FILE_PATH" 2>&1 || true)

# If there's output, send JSON for Claude
if [[ -n "$CONVERT_OUTPUT" ]]; then
    # JSON for Claude (injected into context)
    ESCAPED=$(echo "$CONVERT_OUTPUT" | jq -Rs .)
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
