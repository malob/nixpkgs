#!/usr/bin/env bash
# Auto-format .nix files after edits
#
# This hook runs after Edit/Write tools and formats any .nix file with nixfmt.

set -euo pipefail

file_path=$(jq -r '.tool_input.file_path')

if [[ "$file_path" == *.nix ]]; then
  nixfmt "$file_path" 2>/dev/null || true
fi
