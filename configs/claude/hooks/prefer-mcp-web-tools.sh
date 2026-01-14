#!/usr/bin/env bash
# Soft nudge: Remind Claude to prefer Exa/Firecrawl after using WebSearch/WebFetch
#
# This is a PostToolUse hook - it runs AFTER the tool completes and adds
# context for Claude to consider for future calls.

set -euo pipefail

tool_name=$(jq -r '.tool_name')

if [[ "$tool_name" == "WebSearch" ]]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Reminder: You used WebSearch, but user prefers mcp__exa__web_search_exa or mcp__exa__get_code_context_exa. Please use those for subsequent searches unless there's a specific reason not to."
  }
}
EOF
elif [[ "$tool_name" == "WebFetch" ]]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Reminder: You used WebFetch, but user prefers mcp__firecrawl__firecrawl_scrape. Please use that for subsequent URL fetches unless there's a specific reason not to."
  }
}
EOF
fi

exit 0
