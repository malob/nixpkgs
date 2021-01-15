{ pkgs, lib, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config imported in flake.
  programs.git.enable = true;

  programs.git.extraConfig = {
    core.editor = "${pkgs.neovim-remote}/bin/nvr --remote-wait-silent -cc split";
    diff.colorMoved = "default";
    pull.rebase = true;
  };
  programs.git.userEmail = "mbourgon@gmail.com";
  programs.git.userName = "Malo Bourgon";

  # Enhanced diffs
  programs.git.delta.enable = true;


  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config imported in flake.
  programs.gh.enable = true;

  # `$GITHUB_TOKEN` which `gh` uses for authentication is set in `./private.nix`. `gh auth` can't
  # be used since it tries to write to the config, which is in the store.
  imports = lib.filter lib.pathExists [ ./private.nix ];

  programs.gh.gitProtocol = "ssh";
}
