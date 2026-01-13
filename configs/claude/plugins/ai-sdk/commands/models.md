---
description: Query AI Gateway models (list, filter by provider/tag, get details)
argument-hint: [subcommand] [value]
allowed-tools: Bash
---

Query the Vercel AI Gateway models API.

**Subcommands:**
- `list` or no args - List all models
- `providers` - List all providers
- `tags` - List all capability tags
- `--provider NAME` - Models from a provider (e.g., `--provider anthropic`)
- `--tag TAG` - Models with a capability (e.g., `--tag vision`, `--tag tool-use`)
- `--details ID` - Full details for a model (e.g., `--details openai/gpt-4o`)

Execute: !`${CLAUDE_PLUGIN_ROOT}/skills/ai-sdk-docs/scripts/query-models.sh $ARGUMENTS`

Present the results in a clear, readable format. For `--details`, highlight key information like context window, pricing, and capabilities.
