{ config, lib, pkgs, ... }:

let inherit (lib) mkIf elem; in

{
  # 1Password CLI plugin integration
  # https://developer.1password.com/docs/cli/shell-plugins/nix
  programs._1password-shell-plugins.enable = true;
  programs._1password-shell-plugins.plugins = lib.attrValues ({
    inherit (pkgs)
      gh
      cachix
      ;
  });
  home.shellAliases = {
    # Run `nixpkgs-review` in 1Password env to get `GITHUB_TOKEN` envvar.
    nixpkgs-review = mkIf
      (elem pkgs.nixpkgs-review config.home.packages) "op run -- nixpkgs-review";
  };
  home.sessionVariables = {
    GITHUB_TOKEN = "op://Personal/GitHub Personal Access Token/credential";
  };

  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # SSH
  # https://nix-community.github.io/home-manager/options.html#opt-programs.ssh.enable
  # Some options also set in `../darwin/homebrew.nix`.
  programs.ssh.enable = true;
  programs.ssh.controlPath = "~/.ssh/%C"; # ensures the path is unique but also fixed length

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

  home.packages = lib.attrValues ({
    # Some basics
    inherit (pkgs)
      abduco # lightweight session management
      bandwhich # display current network utilization by process
      bottom # fancy version of `top` with ASCII graphs
      browsh # in terminal browser
      coreutils
      curl
      du-dust # fancy version of `du`
      eza # fancy version of `ls`
      fd # fancy version of `find`
      htop # fancy version of `top`
      hyperfine # benchmarking tool
      mosh # wrapper for `ssh` that better and not dropping connections
      parallel # runs commands in parallel
      ripgrep # better version of `grep`
      tealdeer # rust implementation of `tldr`
      thefuck
      unrar # extract RAR archives
      upterm # secure terminal sharing
      wget
      xz # extract XZ archives
      ;

    # Dev stuff
    inherit (pkgs)
      cloc # source code line counter
      github-copilot-cli
      google-cloud-sdk
      # idris2
      jq
      nodejs
      s3cmd
      stack
      typescript
      ;
    inherit (pkgs.haskellPackages)
      cabal-install
      hoogle
      hpack
      implicit-hie
      ;
    agda = pkgs.agda.withPackages (ps: [ ps.standard-library ]);

    # Useful nix related tools
    inherit (pkgs)
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      nix-output-monitor # get additional information while building packages
      nix-tree # interactively browse dependency graphs of Nix derivations
      nix-update # swiss-knife for updating nix packages
      nixpkgs-review # review pull-requests on nixpkgs
      node2nix # generate Nix expressions to build NPM packages
      statix # lints and suggestions for the Nix programming language
      ;

  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    inherit (pkgs)
      cocoapods
      m-cli # useful macOS CLI commands
      prefmanager # tool for working with macOS defaults
      ;
  });
}
