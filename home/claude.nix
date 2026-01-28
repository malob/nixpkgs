# Claude Code configuration with Nix-managed settings and generated config files.
#
# This module:
# - Wraps claude-code to include --mcp-config flag
# - Generates settings.json with machine-specific paths interpolated
# - Generates MCP configs for both CLI and Desktop from a single source
# - Symlinks other Claude config directories for live editing
#
# MCP servers are defined once and transformed for each target:
# - CLI: stdio servers used directly, HTTP servers used directly
# - Desktop: stdio servers used directly, HTTP bridged via mcp-remote
# - Servers with secrets are wrapped with `op run` to expand op:// references
{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;
  claudeDir = "${nixConfigDirectory}/configs/claude";

  # Path where the MCP config will be generated
  mcpConfigPath = "${config.home.homeDirectory}/.claude/mcp.json";

  # GUI apps don't inherit shell PATH, so we build it from nix-darwin config
  # Expand $HOME and $USER since JSON doesn't support shell variables
  desktopPath =
    builtins.replaceStrings [ "$HOME" "$USER" ] [ config.home.homeDirectory config.home.username ]
      osConfig.environment.systemPath;

  # ============================================================================
  # MCP Server Definitions
  # ============================================================================
  #
  # Each server can specify:
  # - stdio: { command, args?, env? } - Native stdio server
  # - sse: { url } - SSE endpoint (Desktop uses mcp-remote bridge)
  # - http: { url, headers? } - HTTP endpoint (Desktop uses mcp-remote bridge)
  # - desktopOnly / cliOnly: bool - Limit to one target
  #
  # Env vars containing "op://" are automatically expanded via `op run`.
  #
  mcpServers = {
    nixos.stdio = {
      command = "nix";
      args = [
        "run"
        "github:utensils/mcp-nixos"
        "--"
      ];
    };

    exa.stdio = {
      command = "npx";
      args = [
        "-y"
        "exa-mcp-server"
      ];
      env.EXA_API_KEY = "op://Personal/Exa API Key/credential";
    };

    firecrawl.stdio = {
      command = "npx";
      args = [
        "-y"
        "firecrawl-mcp"
      ];
      env.FIRECRAWL_API_KEY = "op://Personal/Firecrawl API Key/credential";
    };

    beeper.stdio = {
      command = "npx";
      args = [
        "-y"
        "@beeper/mcp-remote"
      ];
    };

    # https://developers.asana.com/docs/using-asanas-mcp-server
    asana.sse.url = "https://mcp.asana.com/sse";

    # https://workspacemcp.com/docs
    # Pinned to 1.7.1 due to YAML bug in 1.8.0: https://github.com/taylorwilsdon/google_workspace_mcp/issues/398
    google-workspace.stdio = {
      command = "uvx";
      args = [
        "--from"
        "workspace-mcp==1.7.1"
        "workspace-mcp"
        "--tools"
        "gmail"
        "drive"
        "docs"
        "sheets"
        "calendar"
        "--tool-tier"
        "complete"
        "--single-user"
      ];
      env = {
        GOOGLE_OAUTH_CLIENT_ID = "159058921887-9dude49fdtl0chaq8dklq4pv7tmf00ji.apps.googleusercontent.com";
        GOOGLE_OAUTH_CLIENT_SECRET = "op://Personal/Google Workspace MCP/client_secret";
        GOOGLE_MCP_CREDENTIALS_DIR = "${config.xdg.dataHome}/google-workspace-mcp";
        USER_GOOGLE_EMAIL = "malo@intelligence.org";
      };
    };
  };

  # Claude Desktop preferences (separate from MCP servers)
  desktopPreferences = {
    chromeExtensionEnabled = true;
    quickEntryDictationShortcut = "capslock";
  };

  # ============================================================================
  # Config Generation
  # ============================================================================

  # Check if any env values contain op:// references
  hasOpSecrets = env: lib.any (v: lib.hasPrefix "op://" v) (lib.attrValues env);

  # Wrap a command with `op run` if env contains op:// references
  wrapWithOp =
    {
      command,
      args,
      env,
    }:
    if hasOpSecrets env then
      {
        command = "op";
        args = [
          "run"
          "--"
          command
        ]
        ++ args;
      }
    else
      { inherit command args; };

  # Generate CLI MCP config entry
  mkCliServer =
    name: server:
    let
      env = server.stdio.env or { };
    in
    if server ? sse then
      {
        type = "sse";
        url = server.sse.url;
      }
    else if server ? http then
      {
        type = "http";
        url = server.http.url;
      }
      // lib.optionalAttrs (server.http ? headers) { headers = server.http.headers; }
    else if server ? stdio then
      let
        wrapped = wrapWithOp {
          inherit (server.stdio) command;
          inherit env;
          args = server.stdio.args or [ ];
        };
      in
      {
        type = "stdio";
        inherit (wrapped) command args;
        inherit env;
      }
    else
      throw "MCP server '${name}' must define 'sse', 'http', or 'stdio'";

  # Generate Desktop MCP config entry
  # Desktop requires stdio, so HTTP/SSE servers are bridged via mcp-remote
  mkDesktopServer =
    name: server:
    let
      env = server.stdio.env or { };

      # Get base command/args (bridge HTTP/SSE via mcp-remote)
      base =
        if server ? sse then
          {
            command = "npx";
            args = [
              "-y"
              "mcp-remote"
              server.sse.url
            ];
          }
        else if server ? http then
          {
            command = "npx";
            args = [
              "-y"
              "mcp-remote"
              server.http.url
            ];
          }
        else if server ? stdio then
          {
            inherit (server.stdio) command;
            args = server.stdio.args or [ ];
          }
        else
          throw "MCP server '${name}' must define 'sse', 'http', or 'stdio'";

      wrapped = wrapWithOp (base // { inherit env; });
    in
    {
      inherit (wrapped) command args;
      env = env // {
        PATH = desktopPath;
      };
    };

  # Filter and transform servers for each target
  cliServers = lib.filterAttrs (_: s: !(s.desktopOnly or false)) mcpServers;
  desktopServers = lib.filterAttrs (_: s: !(s.cliOnly or false)) mcpServers;

  cliMcpConfig.mcpServers = lib.mapAttrs mkCliServer cliServers;
  desktopConfig = {
    mcpServers = lib.mapAttrs mkDesktopServer desktopServers;
    preferences = desktopPreferences;
  };

  # ============================================================================
  # Settings
  # ============================================================================
  # Generated by Nix to interpolate machine-specific paths.
  # To modify permissions or plugins, edit this section and rebuild.

  settings = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";

    permissions.allow = [
      # Nix config directory (includes Claude config, plugins, etc.)
      "Edit(${nixConfigDirectory}/**)"
      "Write(${nixConfigDirectory}/**)"
      # Read-only git and file inspection
      "Bash(git status:*)"
      "Bash(git diff:*)"
      "Bash(git log:*)"
      "Bash(git branch:*)"
      "Bash(git show:*)"
      "Bash(ls:*)"
      "Bash(cat:*)"
      "Bash(head:*)"
      "Bash(tail:*)"
      # Nix commands
      "Bash(nix build:*)"
      "Bash(nix flake:*)"
      "Bash(nix eval:*)"
      "Bash(nix develop:*)"
      # GitHub CLI read operations
      "Bash(gh pr view:*)"
      "Bash(gh pr list:*)"
      "Bash(gh pr diff:*)"
      "Bash(gh pr checks:*)"
      "Bash(gh issue view:*)"
      "Bash(gh issue list:*)"
      # TTS plugin skills
      "Skill(tts:*)"
      # MCP web tools
      "mcp__exa__web_search_exa"
      "mcp__exa__get_code_context_exa"
      "mcp__firecrawl__firecrawl_scrape"
      "mcp__firecrawl__firecrawl_map"
      "mcp__firecrawl__firecrawl_crawl"
      "mcp__firecrawl__firecrawl_check_crawl_status"
      "mcp__firecrawl__firecrawl_extract"
      "mcp__firecrawl__firecrawl_batch_scrape"
    ];

    enabledPlugins = {
      "plugin-dev@claude-plugins-official" = true;
      "commit-commands@claude-plugins-official" = true;
      "frontend-design@claude-plugins-official" = true;
      "feature-dev@claude-plugins-official" = true;
      "pr-review-toolkit@claude-plugins-official" = true;
      "nix-lsp@malos-plugins" = true;
      "json-lsp@malos-plugins" = true;
      "tts@malos-plugins" = true;
      "pua-unicode@malos-plugins" = true;
    };

    extraKnownMarketplaces.malos-plugins.source = {
      source = "directory";
      path = "${claudeDir}/plugins";
    };

    additionalDirectories = [ nixConfigDirectory ];

    hooks = {
      PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "${claudeDir}/hooks/op-plugin-wrap.sh";
            }
          ];
        }
      ];
      PostToolUse = [
        {
          matcher = "WebSearch|WebFetch";
          hooks = [
            {
              type = "command";
              command = "${claudeDir}/hooks/prefer-mcp-web-tools.sh";
            }
          ];
        }
        {
          matcher = "Edit|Write";
          hooks = [
            {
              type = "command";
              command = "${claudeDir}/hooks/shellcheck-lint.sh";
            }
          ];
        }
      ];
      Notification = [
        {
          hooks = [
            {
              type = "command";
              command = "${claudeDir}/hooks/notify-ghostty.sh";
            }
          ];
        }
      ];
    };

    statusLine = {
      type = "command";
      command = "${claudeDir}/statusline.sh";
      padding = 0;
    };
  };

  # Helper for human-readable JSON files
  toFormattedJSON =
    data:
    pkgs.runCommand "formatted.json"
      {
        nativeBuildInputs = [ pkgs.jq ];
        passAsFile = [ "json" ];
        json = builtins.toJSON data;
      }
      ''
        jq . "$jsonPath" > $out
      '';

in
{
  # Shell alias adds --mcp-config flag (Homebrew installs the binary via cask)
  home.shellAliases.claude = "claude --mcp-config ${mcpConfigPath}";

  home.file = {
    # Generated by Nix (machine-specific paths)
    ".claude/settings.json".source = toFormattedJSON settings;
    ".claude/mcp.json".source = toFormattedJSON cliMcpConfig;

    # Symlinked for live editing
    ".claude/CLAUDE.md".source = mkOutOfStoreSymlink "${claudeDir}/CLAUDE.md";
    ".claude/commands".source = mkOutOfStoreSymlink "${claudeDir}/commands";
    ".claude/skills".source = mkOutOfStoreSymlink "${claudeDir}/skills";
    ".claude/agents".source = mkOutOfStoreSymlink "${claudeDir}/agents";
    ".claude/rules".source = mkOutOfStoreSymlink "${claudeDir}/rules";
    ".claude/hooks".source = mkOutOfStoreSymlink "${claudeDir}/hooks";

    # Claude Desktop config
    "Library/Application Support/Claude/claude_desktop_config.json".source =
      toFormattedJSON desktopConfig;
  };
}
