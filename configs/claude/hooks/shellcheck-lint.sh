#!/usr/bin/env bash
# Run shellcheck on shell scripts after Edit/Write

set -euo pipefail

file_path=$(jq -r '.tool_input.file_path // empty')

# Only check .sh files
[[ "$file_path" != *.sh ]] && exit 0

# Run shellcheck and capture output
output=$(shellcheck "$file_path" 2>&1) || true

# Only output if there are issues
if [[ -n "$output" ]]; then
  # Escape the output for JSON
  escaped_output=$(echo "$output" | jq -Rs .)
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": $escaped_output
  }
}
EOF
fi
