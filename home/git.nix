{ pkgs, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git.enable = true;

  programs.git.extraConfig = {
    core.editor = "${pkgs.neovim-remote}/bin/nvr --remote-wait-silent -cc split";
    diff.colorMoved = "default";
    pull.rebase = true;
  };

  programs.git.ignores = [
    ".DS_Store"
  ];

  programs.git.userEmail = "mbourgon@gmail.com";
  programs.git.userName = "Malo Bourgon";

  # Enhanced diffs
  programs.git.delta.enable = true;


  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
