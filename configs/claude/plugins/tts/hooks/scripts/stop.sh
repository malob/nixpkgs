#!/usr/bin/env bash
# Stop hook: Offer audio summary when Claude finishes responding
#
# Only offers TTS if enabled for this session (via SessionStart hook).
# Captures response to temp file and blocks with instruction to offer audio.

set -euo pipefail

# Skip if we're inside a TTS subprocess (prevents recursive hook triggering)
if [[ "${TTS_SUBPROCESS:-}" == "1" ]]; then
  exit 0
fi

INPUT=$(cat)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

# Check if TTS is enabled for this session
TTS_ENABLED_FILE="${TMPDIR:-/tmp}/tts-enabled-${SESSION_ID}"
if [[ ! -f "$TTS_ENABLED_FILE" ]]; then
  exit 0  # TTS not enabled, allow normal stop
fi

# Use session-specific file to avoid conflicts between concurrent sessions
TTS_RESPONSE_FILE="${TMPDIR:-/tmp}/tts-response-${SESSION_ID}.txt"

# Only block first stop attempt
if [[ "$STOP_HOOK_ACTIVE" == "false" ]]; then
  # Capture the last assistant text response NOW, before transcript gets more entries
  jq -rs '
    [.[] | select(.type == "assistant") | select(.message.content | map(.type) | contains(["text"]))]
    | last | .message.content[] | select(.type == "text") | .text
  ' "$TRANSCRIPT_PATH" 2>/dev/null > "$TTS_RESPONSE_FILE"

  # Only offer TTS for substantial responses (>500 chars)
  RESPONSE_LENGTH=$(wc -c < "$TTS_RESPONSE_FILE" | tr -d ' ')
  if [[ "$RESPONSE_LENGTH" -lt 500 ]]; then
    rm -f "$TTS_RESPONSE_FILE"  # Clean up to avoid stale file being used by manual /tts:say
    exit 0
  fi

  # Block and instruct Claude to run TTS
  cat << 'EOF'
{
  "decision": "block",
  "reason": "Run /tts:say to speak this response aloud."
}
EOF
  exit 0
fi

# Allow subsequent stops (after user accepted/denied audio)
exit 0
