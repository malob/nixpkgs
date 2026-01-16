#!/usr/bin/env bash
# Claude Code status line with Starship integration
# Format: [Starship prompt] │ Model │ $Cost │ Context%

set -euo pipefail

input=$(cat)
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
MODEL=$(echo "$input" | jq -r '.model.display_name')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

# Calculate context percentage (include cache tokens per official docs)
if [ "$USAGE" != "null" ]; then
  CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  PERCENT=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
else
  CURRENT_TOKENS=0
  PERCENT=0
fi

# Format as "Xk/Yk"
CURRENT_K=$((CURRENT_TOKENS / 1000))
SIZE_K=$((CONTEXT_SIZE / 1000))

# Circle slice icons (nf-md-circle_slice_1 through 8)
# Maps percentage to progressively filling circle
if   [ "$PERCENT" -lt 13 ]; then ICON="󰪞"
elif [ "$PERCENT" -lt 25 ]; then ICON="󰪟"
elif [ "$PERCENT" -lt 38 ]; then ICON="󰪠"
elif [ "$PERCENT" -lt 50 ]; then ICON="󰪡"
elif [ "$PERCENT" -lt 63 ]; then ICON="󰪢"
elif [ "$PERCENT" -lt 75 ]; then ICON="󰪣"
elif [ "$PERCENT" -lt 88 ]; then ICON="󰪤"
else ICON="󰪥"
fi

# Color based on context usage (ANSI escape codes)
# Green (0-50%): safe, Yellow (50-75%): getting full, Orange (75-90%): should compact, Red (90%+): critical
if   [ "$PERCENT" -lt 50 ]; then COLOR="\033[32m"  # green
elif [ "$PERCENT" -lt 75 ]; then COLOR="\033[33m"  # yellow
elif [ "$PERCENT" -lt 90 ]; then COLOR="\033[91m"  # bright red (orange in Solarized)
else COLOR="\033[31m"  # red
fi
RESET="\033[0m"

# Starship prompt (line 2 has content, line 1 is clear-screen, line 3 is prompt char)
# Strip leading shlvl indicator (e.g., " 3" showing shell depth)
STARSHIP=$(starship prompt -p "$DIR" 2>/dev/null | sed -n '2p' | sed 's/^\x1b\[[0-9;]*m[^[]*\x1b\[0m //')

# Output linear format
printf "%s  󰚩 %s · ${COLOR}%s %dk/%dk (%d%%)${RESET}" "$STARSHIP" "$MODEL" "$ICON" "$CURRENT_K" "$SIZE_K" "$PERCENT"
