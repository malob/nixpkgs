#!/usr/bin/env bash
# SessionStart hook: Capture session ID for TTS commands
#
# Persists CLAUDE_SESSION_ID to the environment file so that
# /tts:start, /tts:stop, and /tts:say commands can access it.
# This hook is silent - it doesn't prompt about TTS.

set -euo pipefail

# Read input from stdin
input=$(cat 2>/dev/null || echo '{}')

# Parse session_id
session_id=$(echo "$input" | jq -r '.session_id // empty')

if [ -z "$session_id" ]; then
  exit 0
fi

# Persist session ID to environment for commands to use
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo "export CLAUDE_SESSION_ID=$session_id" >> "$CLAUDE_ENV_FILE"
fi

exit 0
