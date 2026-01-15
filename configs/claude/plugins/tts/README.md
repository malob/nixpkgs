# TTS Plugin

Text-to-speech for Claude Code responses on macOS.

## Requirements

- macOS (uses the `say` command — not available on Linux/Windows)
- Claude CLI with valid authentication (for Haiku summarization)

## Commands

| Command           | Description                                                             |
| ----------------- | ----------------------------------------------------------------------- |
| `/tts:start`      | Enable auto-TTS for this session                                        |
| `/tts:stop`       | Disable auto-TTS for this session                                       |
| `/tts:say [rate]` | Manually speak the last response (rate: words per minute, default 300)  |
| `/tts:cancel`     | Stop any currently playing audio                                        |

## How It Works

When auto-TTS is enabled via `/tts:start`:

1. After Claude finishes a substantial response (>500 characters), you'll be prompted to play an audio summary
2. If you approve, the response is summarized using Haiku (converting code/technical content to natural speech)
3. The summary is spoken aloud via macOS text-to-speech

The confirmation prompt prevents unexpected audio when running multiple sessions or when you're away from your computer.

## Notes

- Only responses over 500 characters trigger the auto-TTS prompt
- Speaking rate range: 150–400 wpm recommended (default: 300)
- Voice is your macOS default (System Settings → Accessibility → Spoken Content)
- Changes to plugin source require restarting Claude Code

## Examples

```
# Enable auto-TTS
/tts:start

# ... Claude gives a long response ...
# You'll see: "Play audio summary of last response?"
# Approve to hear it spoken

# Manually speak at a slower rate (200 wpm)
/tts:say 200

# Disable auto-TTS
/tts:stop
```
