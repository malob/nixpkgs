# AI SDK Plugin for Claude Code

Tools for working with the Vercel AI SDK - documentation lookup, model queries, and AI Gateway integration.

## Components

### Agent: ai-sdk-explorer

Autonomous documentation researcher that fetches current AI SDK documentation on demand. Triggers proactively when:
- Implementing AI SDK features
- Debugging AI SDK issues
- Verifying correct API usage
- Looking up model capabilities

### Command: /models

Query the AI Gateway models API:

```
/models                     # List all models
/models providers           # List all providers
/models tags                # List all capability tags
/models --provider anthropic  # Models from a provider
/models --tag vision        # Models with a capability
/models --details gpt-4o    # Full details for a model
```

### Skill: ai-sdk-docs

Core knowledge and utility scripts for accessing AI SDK documentation:
- `list-docs.sh` - Discover available documentation pages
- `fetch-doc.sh` - Fetch full markdown content of a page
- `query-models.sh` - Query the AI Gateway models API

## Installation

```bash
claude --plugin-dir /path/to/ai-sdk-plugin
```

## Usage

The plugin works automatically - when you're working with AI SDK code, Claude will proactively research documentation as needed. You can also:

- Run `/models` to query available models
- Ask questions about AI SDK and the agent will fetch current docs
