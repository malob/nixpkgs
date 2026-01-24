#!/usr/bin/env bash
# PreToolUse hook: Wraps commands with `op plugin run --` for 1Password integration
# This enables 1Password shell plugins to work in non-interactive shells like Claude Code
#
# Commands wrapped: gh, cachix (add more as needed)

set -euo pipefail

# Small delay before reading stdin - works around race condition
# where Claude Code hasn't finished writing input to the pipe
sleep 0.01

input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')

# Check if command starts with a tool that needs op plugin wrapping
# Using word boundary to match "gh" or "gh " but not "ghc" or "ghost"
if [[ "$cmd" =~ ^(gh|cachix)($|[[:space:]]) ]]; then
  # Wrap with op plugin run for 1Password credential injection
  modified_cmd="op plugin run -- $cmd"
  # Capture then echo to ensure complete output
  output=$(jq -n --arg cmd "$modified_cmd" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      updatedInput: {
        command: $cmd
      }
    }
  }')
  echo "$output"
fi

# If no match, output nothing (allows command to proceed unchanged)
