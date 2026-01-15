# Nix LSP Plugin

Language server integration for Nix files using [nixd](https://github.com/nix-community/nixd).

## Requirements

- `nixd` must be installed and available in PATH

## Features

Provides Claude Code with LSP capabilities for `.nix` files:

- Go to definition
- Find references
- Hover information
- Diagnostics and error checking
- Code completion

## Configuration

The plugin uses `.lsp.json` to configure the language server:

```json
{
  "nix": {
    "command": "nixd",
    "extensionToLanguage": {
      ".nix": "nix"
    }
  }
}
```

## Usage

Once enabled, LSP features work automatically when editing Nix files. Claude can use the LSP tool to navigate definitions, find references, and get hover documentation.
