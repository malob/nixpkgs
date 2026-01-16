#!/usr/bin/env bash
# Trigger native Ghostty notification via OSC 777 escape sequence
# Used by Claude Code's Notification hook for permission prompts, idle alerts, etc.

set -euo pipefail

input=$(cat)
notification_type=$(echo "$input" | jq -r '.notification_type // "unknown"')
message=$(echo "$input" | jq -r '.message // "Needs attention"')
cwd=$(echo "$input" | jq -r '.cwd // ""')

# Get project name from cwd (last directory component)
project=""
if [[ -n "$cwd" ]]; then
  project=$(basename "$cwd")
fi

# Build a more informative title based on notification type
case "$notification_type" in
  permission_prompt)
    title="Permission needed"
    ;;
  idle_prompt)
    title="Waiting for input"
    ;;
  *)
    title="Claude Code"
    ;;
esac

# Append project name if available
if [[ -n "$project" ]]; then
  title="$title ($project)"
fi

# Write directly to the terminal (not stdout which goes to Claude Code)
# shellcheck disable=SC1003 # \e\\ is ESC+backslash (ST), not a quote escape
printf '\e]777;notify;%s;%s\e\\' "$title" "$message" > /dev/tty 2>/dev/null || true
