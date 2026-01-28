#!/usr/bin/env bash
# TTS script: Transform and speak Claude's last response
#
# Can be called two ways:
# 1. By Stop hook: temp file already contains the response
# 2. Manually via /tts command: extracts response from transcript
#
# Uses claude CLI to transform for audio, then speaks via macOS say.

set -euo pipefail

# Check dependencies
if ! command -v say &>/dev/null; then
  echo "Error: 'say' command not found (this plugin requires macOS)" >&2
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "Error: 'jq' command not found (install via: brew install jq)" >&2
  exit 1
fi

if ! command -v claude &>/dev/null; then
  echo "Error: 'claude' CLI not found (install from: https://claude.ai/code)" >&2
  exit 1
fi

# Arguments
SESSION_ID="${1:-}"
RATE="${2:-300}"  # Words per minute (default: 300)

# Clean up auto-pending marker if it exists (belt-and-suspenders with PreToolUse hook)
rm -f "${TMPDIR:-/tmp}/tts-auto-pending-${SESSION_ID}"

if [[ -z "$SESSION_ID" ]]; then
  SESSION_ID=$(find ~/.claude -name "*.jsonl" -mmin -5 2>/dev/null | head -1 | xargs basename 2>/dev/null | sed 's/.jsonl//')
  if [[ -z "$SESSION_ID" ]]; then
    echo "Error: Could not determine session ID" >&2
    exit 1
  fi
fi

# Use session-specific file to avoid conflicts between concurrent sessions
TTS_RESPONSE_FILE="${TMPDIR:-/tmp}/tts-response-${SESSION_ID}.txt"

# Try to get response from temp file (Stop hook path) or extract from transcript (manual path)
if [[ -f "$TTS_RESPONSE_FILE" ]]; then
  # Stop hook already captured the response
  LAST_RESPONSE=$(cat "$TTS_RESPONSE_FILE")
  rm -f "$TTS_RESPONSE_FILE"
else
  # Manual invocation - extract from transcript
  TRANSCRIPT=$(find ~/.claude -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)
  if [[ -z "$TRANSCRIPT" ]]; then
    echo "Error: Could not find transcript for session $SESSION_ID" >&2
    exit 1
  fi
  LAST_RESPONSE=$(jq -rs '
    [.[] | select(.type == "assistant") | select(.message.content | map(.type) | contains(["text"]))]
    | last | .message.content[] | select(.type == "text") | .text
  ' "$TRANSCRIPT" 2>/dev/null)
fi

# If we couldn't extract a response, exit silently
if [[ -z "$LAST_RESPONSE" ]]; then
  echo "No assistant response found to speak" >&2
  exit 0
fi

# Transformation prompt for claude CLI
PROMPT='Transform this Claude Code response for text-to-speech. Output ONLY the spoken text - no preamble, no commentary. Your entire response will be fed directly to TTS.

GOAL: Preserve the full content, just make it pleasant to listen to.

TRANSFORM for audio:
- Code snippets → describe what the code does (code cannot be read aloud)
- File paths → mention the filename naturally
- Technical formatting (bullets, headers) → natural spoken flow

KEEP as-is:
- Explanations, reasoning, details - do not compress these
- The substance of what was said

STYLE:
- First person, natural speech
- Spell out abbreviations (API → "A P I")
- Numbers sound natural (8080 → "eighty eighty")

Response to transform:

'"$LAST_RESPONSE"

# Call claude CLI for transformation
# --print for non-interactive single-response mode
# Run from /tmp so session history doesn't pollute project conversations
# TTS_SUBPROCESS=1 prevents the Stop hook from triggering recursively
SPOKEN_TEXT=$(cd "${TMPDIR:-/tmp}" && echo "$PROMPT" | TTS_SUBPROCESS=1 command claude --print --model haiku 2>/dev/null) || true

# Check if transformation failed
if [[ -z "$SPOKEN_TEXT" ]]; then
  echo "Error: Transformation failed (is Claude CLI authenticated?)" >&2
  exit 1
fi

# Speak the transformed text via macOS text-to-speech
# Using temp file + -f flag instead of pipe to avoid choppy audio/dropouts
SPOKEN_TEXT_FILE=$(mktemp)
trap 'rm -f "$SPOKEN_TEXT_FILE"' EXIT
echo "$SPOKEN_TEXT" > "$SPOKEN_TEXT_FILE"
say -r "$RATE" -f "$SPOKEN_TEXT_FILE"
