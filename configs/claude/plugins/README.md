# Malo's Plugins

A collection of Claude Code plugins for personal use.

## Plugins

| Plugin      | Description                                                   |
| ----------- | ------------------------------------------------------------- |
| ai-sdk      | Vercel AI SDK documentation lookup and model queries          |
| json-lsp    | JSON language server for schema validation and diagnostics    |
| nix-lsp     | Nix language server integration using nixd                    |
| pua-unicode | Workaround for BMP PUA filtering (Nerd Font icons)            |
| tts         | Text-to-speech for Claude responses (macOS)                   |

See each plugin's README for details.

## Installation

```
/plugin marketplace add https://raw.githubusercontent.com/malob/nix-config/master/configs/claude/plugins/.claude-plugin/marketplace.json
```

Then enable individual plugins via `/plugin`.
