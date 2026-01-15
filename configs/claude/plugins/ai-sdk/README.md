# AI SDK Plugin

Tools for working with the Vercel AI SDK — documentation lookup, model queries, and AI Gateway integration.

## Components

### Agent: ai-sdk-explorer

Autonomous documentation researcher that fetches current AI SDK documentation on demand. Triggers proactively when:
- Implementing AI SDK features
- Debugging AI SDK issues
- Verifying correct API usage
- Looking up model capabilities

### Command: /ai-sdk:models

Query the AI Gateway models API:

```
/ai-sdk:models                       # List all models
/ai-sdk:models providers             # List all providers
/ai-sdk:models tags                  # List all capability tags
/ai-sdk:models --provider anthropic  # Models from a provider
/ai-sdk:models --tag vision          # Models with a capability
/ai-sdk:models --details gpt-4o      # Full details for a model
```

### Skill: ai-sdk-docs

Core knowledge and utility scripts for accessing AI SDK documentation:
- `list-docs.sh` - Discover available documentation pages
- `fetch-doc.sh` - Fetch full markdown content of a page
- `query-models.sh` - Query the AI Gateway models API

## Usage

The plugin works automatically — when you're working with AI SDK code, Claude will proactively research documentation as needed. You can also:

- Run `/ai-sdk:models` to query available models
- Ask questions about AI SDK and the agent will fetch current docs
