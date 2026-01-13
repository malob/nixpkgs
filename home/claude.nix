# Claude Code configuration with live-editable config files via symlinks.
#
# This module:
# - Wraps claude-code to include --mcp-config flag pointing to a live-editable file
# - Symlinks all Claude config directories into the nix config repo for live editing
# - Integrates with 1Password shell plugins if enabled
#
# All config files live in `configs/claude/` and can be edited without rebuilding.
{ config, pkgs, lib, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;
  claudeDir = "${nixConfigDirectory}/configs/claude";

  # Path where the MCP config will be symlinked (must be absolute for the wrapper)
  mcpConfigPath = "${config.home.homeDirectory}/.claude/mcp.json";

  # Wrap claude-code to include --mcp-config flag
  claude-code-wrapped = pkgs.symlinkJoin {
    name = "claude-code-wrapped";
    paths = [ pkgs.claude-code ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --append-flags "--mcp-config ${mcpConfigPath}"
    '';
    meta.mainProgram = "claude";
  };
in
{
  # Install wrapped claude-code
  home.packages = [ claude-code-wrapped ];

  # Shell alias for 1Password integration (only if 1Password shell plugins are enabled)
  # --no-masking is a workaround for https://github.com/anthropics/claude-code/issues/7432
  home.shellAliases.claude = lib.mkIf config.programs._1password-shell-plugins.enable
    "op run --no-masking -- claude";

  # Symlink all Claude config for live editing
  home.file = {
    ".claude/CLAUDE.md".source = mkOutOfStoreSymlink "${claudeDir}/CLAUDE.md";
    ".claude/settings.json".source = mkOutOfStoreSymlink "${claudeDir}/settings.json";
    ".claude/mcp.json".source = mkOutOfStoreSymlink "${claudeDir}/mcp.json";
    ".claude/commands".source = mkOutOfStoreSymlink "${claudeDir}/commands";
    ".claude/skills".source = mkOutOfStoreSymlink "${claudeDir}/skills";
    ".claude/agents".source = mkOutOfStoreSymlink "${claudeDir}/agents";
    ".claude/rules".source = mkOutOfStoreSymlink "${claudeDir}/rules";
    ".claude/hooks".source = mkOutOfStoreSymlink "${claudeDir}/hooks";
  };
}
