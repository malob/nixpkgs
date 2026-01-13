# Malo's Global Claude Context

## Environment
- macOS with nix-darwin and Home Manager
- Nix config at `~/.config/nixpkgs`
- Fish shell with Starship prompt
- 1Password for secrets management

## Tools
- Ghostty terminal
- GitHub CLI (`gh`) for PRs and issues
- `comma` for ad-hoc access to any nixpkgs command (`, <cmd>` runs without installing)

## Languages
- Primary: Nix, Haskell, TypeScript/JavaScript, Python
- Modern tooling: pnpm, uv, Stack

## Git Workflow
- Rebase-based (pull.rebase = true)
- SSH protocol for GitHub
- Commit messages: imperative mood, concise

## Code Style
- Functional programming: strong types, immutability, composition
- These are strong preferences, not dogma—simplicity wins when trade-offs arise
- Nix: follow nixpkgs conventions
- Small, focused functions
- Avoid over-engineering

## Evolving Configuration
Proactively suggest improvements to Claude Code configuration based on our conversations:
- Preferences or patterns → CLAUDE.md (global or project-level)
- Repeated permission friction → settings.json allow rules
- Workflow automations → hooks, custom commands, agents, etc.
- Project-specific settings → project settings.json
- Tool integrations → MCP servers
- Anything else that would reduce friction or improve our collaboration

Propose changes rather than making them silently.
