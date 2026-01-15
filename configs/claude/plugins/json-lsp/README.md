# JSON LSP Plugin

Language server integration for JSON files using [vscode-json-language-server](https://github.com/microsoft/vscode-json-languageservice).

## Requirements

- `vscode-json-language-server` must be installed and available in PATH
  - Install via npm: `npm install -g vscode-langservers-extracted`

## Features

Provides Claude Code with LSP capabilities for JSON files:

- Schema validation
- Diagnostics and error checking
- Hover information for schema-documented fields
- Code completion based on JSON schemas

## Supported Extensions

| Extension | Language |
| --------- | -------- |
| `.json`   | json     |
| `.jsonc`  | jsonc    |

## Configuration

The plugin uses `.lsp.json` to configure the language server:

```json
{
  "json": {
    "command": "vscode-json-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".json": "json",
      ".jsonc": "jsonc"
    }
  }
}
```

## Usage

Once enabled, LSP features work automatically when editing JSON files. Claude can use the LSP tool to validate JSON against schemas and get hover documentation.
