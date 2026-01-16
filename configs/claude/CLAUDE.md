# Malo's Global Claude Context

## Personal Context
Biographical info (job, preferences, interests) is auto-loaded from `~/.claude/rules/bio.md`.

For private details (phone, address, contact info), read `~/.claude/PRIVATE.md` when needed for tasks like filling forms or making reservations.

## Environment
- macOS with nix-darwin and Home Manager
- Nix config at `~/.config/nix-config`
- Fish shell with Starship prompt
- 1Password for secrets management

## Tools
- Ghostty terminal
- GitHub CLI (`gh`) for PRs and issues
- `comma` for ad-hoc access to any nixpkgs command (`, <cmd>` runs without installing)

## Web Tools

**Prefer MCP tools over built-in WebSearch/WebFetch.**

### Search/Discovery → Exa
When you need to find information but don't have a URL:
- `mcp__exa__web_search_exa` - General web search
- `mcp__exa__get_code_context_exa` - Code/programming (docs, examples, APIs, GitHub)

**Query style:** Write natural language questions, not keyword lists. Exa uses semantic search that understands meaning.
- Good: "What are the common issues users experience with Firecrawl's MCP server?"
- Bad: "Firecrawl MCP server issues problems bugs"

### Content Extraction → Firecrawl
When you have a URL and need its content:
- `firecrawl_scrape` - Single URL (default choice)
- `firecrawl_batch_scrape` - Multiple known URLs
- `firecrawl_map` - Discover URLs on a site (returns list only)
- `firecrawl_crawl` - Multi-page extraction (use sparingly, set low `limit`)
- `firecrawl_extract` - Structured JSON with schema

**Avoid:**
- `firecrawl_search` and `firecrawl_agent` - redundant (Exa handles search, you're the agent)
- Built-in WebSearch/WebFetch - use Exa/Firecrawl instead

**Firecrawl tips:**
- `onlyMainContent: true` - strips nav/footer noise
- `maxAge: 86400000` - use 1-day cache for speed
- For docs sites: `map` first → filter URLs → `batch_scrape`

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
