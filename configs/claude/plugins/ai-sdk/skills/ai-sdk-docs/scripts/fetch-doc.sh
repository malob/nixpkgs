#!/bin/bash
# fetch-doc.sh - Fetch a specific AI SDK documentation page as markdown
# Usage: fetch-doc.sh <path>
# Example: fetch-doc.sh /docs/ai-sdk-core/streaming

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: fetch-doc.sh <path>"
  echo "Example: fetch-doc.sh /docs/ai-sdk-core/streaming"
  exit 1
fi

DOC_PATH="$1"
BASE_URL="https://ai-sdk.dev"

# Remove leading slash if present for consistency
DOC_PATH="${DOC_PATH#/}"

# Try fetching the .md version
MD_URL="${BASE_URL}/${DOC_PATH}.md"

response=$(curl -s -w "\n%{http_code}" "$MD_URL")
http_code=$(echo "$response" | tail -n1)
content=$(echo "$response" | sed '$d')

if [[ "$http_code" == "200" ]]; then
  echo "$content"
else
  # .md version failed, try without .md extension (some pages may not support it)
  FALLBACK_URL="${BASE_URL}/${DOC_PATH}"
  fallback_response=$(curl -s -w "\n%{http_code}" "$FALLBACK_URL")
  fallback_code=$(echo "$fallback_response" | tail -n1)

  if [[ "$fallback_code" == "200" ]]; then
    echo "# Note: .md version not available, fetched HTML page instead"
    echo "# You may want to use a different approach for this page"
    echo "# URL: $FALLBACK_URL"
    echo ""
    # Just note that it's HTML - dumping raw HTML isn't useful
    echo "This page doesn't have a .md version available."
    echo "Visit: $FALLBACK_URL"
  else
    echo "Error: Could not fetch document at $DOC_PATH"
    echo "Tried: $MD_URL (HTTP $http_code)"
    echo "Tried: $FALLBACK_URL (HTTP $fallback_code)"
    exit 1
  fi
fi
