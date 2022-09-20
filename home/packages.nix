{ config, lib, pkgs, ... }:

{
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

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    # Some basics
    abduco # lightweight session management
    bandwhich # display current network utilization by process
    bottom # fancy version of `top` with ASCII graphs
    browsh # in terminal browser
    coreutils
    curl
    du-dust # fancy version of `du`
    exa # fancy version of `ls`
    fd # fancy version of `find`
    htop # fancy version of `top`
    hyperfine # benchmarking tool
    mosh # wrapper for `ssh` that better and not dropping connections
    nodePackages.speed-test # nice speed-test tool
    parallel # runs commands in parallel
    # python3Packages.shell-functools # a collection of functional programming tools for the shell
    ripgrep # better version of `grep`
    tealdeer # rust implementation of `tldr`
    thefuck
    unrar # extract RAR archives
    wget
    xz # extract XZ archives

    # Dev stuff
    # (agda.withPackages (p: [ p.standard-library ]))
    cloc # source code line counter
    google-cloud-sdk
    haskellPackages.cabal-install
    haskellPackages.hoogle
    haskellPackages.hpack
    haskellPackages.implicit-hie
    haskellPackages.stack
    idris2
    jq
    nodePackages.typescript
    nodejs-16_x
    s3cmd

    # Useful nix related tools
    cachix # adding/managing alternative binary caches hosted by Cachix
    comma # run software from without installing it
    niv # easy dependency management for nix projects
    nix-tree # interactively browse dependency graphs of Nix derivations
    nix-update # swiss-knife for updating nix packages
    nixpkgs-review # review pull-requests on nixpkgs
    nodePackages.node2nix
    statix # lints and suggestions for the Nix programming language

  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli # useful macOS CLI commands
    prefmanager # tool for working with macOS defaults
  ];
}
