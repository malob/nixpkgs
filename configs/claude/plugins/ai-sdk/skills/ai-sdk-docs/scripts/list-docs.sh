#!/bin/bash
# list-docs.sh - List all AI SDK documentation pages from the sitemap
# Usage: list-docs.sh [category]
# Categories: docs, cookbook, providers, elements, tools-registry
# If no category provided, lists all pages grouped by category

set -euo pipefail

SITEMAP_URL="https://ai-sdk.dev/sitemap.xml"
FILTER_CATEGORY="${1:-}"

# Fetch sitemap and extract URLs (portable sed instead of grep -P)
urls=$(curl -s "$SITEMAP_URL" | sed -n 's/.*<loc>\([^<]*\)<\/loc>.*/\1/p' | sort)

if [[ -n "$FILTER_CATEGORY" ]]; then
  # Filter to specific category
  echo "$urls" | grep "^https://ai-sdk.dev/${FILTER_CATEGORY}" | sed 's|https://ai-sdk.dev||'
else
  # Group by category
  categories=("docs" "cookbook" "providers" "elements" "tools-registry")

  for category in "${categories[@]}"; do
    matches=$(echo "$urls" | grep "^https://ai-sdk.dev/${category}" | sed 's|https://ai-sdk.dev||' || true)
    if [[ -n "$matches" ]]; then
      count=$(echo "$matches" | wc -l | tr -d ' ')
      echo "=== /${category} (${count} pages) ==="
      echo "$matches"
      echo ""
    fi
  done

  # Root level pages (not in any category)
  root_pages=$(echo "$urls" | grep -E "^https://ai-sdk.dev/[^/]*$" | sed 's|https://ai-sdk.dev||' || true)
  if [[ -n "$root_pages" ]]; then
    count=$(echo "$root_pages" | wc -l | tr -d ' ')
    echo "=== / (root - ${count} pages) ==="
    echo "$root_pages"
  fi
fi
