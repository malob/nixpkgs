{ config, pkgs, lib, ... }:

{
  # Import config broken out into files
  imports = [
    ./git.nix
    ./neovim.nix
    ./shells.nix
  ] ++ lib.filter lib.pathExists [ ./private.nix ];

  # Packages with coinfiguration --------------------------------------------------------------- {{{

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

  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  # Configuration options defined in overlays: `../overlays/kitty-configs.nix`
  programs.kitty.enable = true;
  programs.kitty.settings = pkgs.my-kitty-config // pkgs.my-kitty-light-config;
  xdg.configFile."kitty/macos-launch-services-cmdline" = lib.mkIf pkgs.stdenv.isDarwin {
    text = "--listen-on unix:/tmp/mykitty";
  };
  programs.fish.functions.set-term-colors = lib.mkIf config.programs.kitty.enable {
    body = ''
      # Check whether Fish is running inside a Kitty window, if it is change the colorscheme based
      # on `$term_background`.
      if test -n "$KITTY_WINDOW_ID"
        kitty @ --to $KITTY_LISTEN_ON set-colors --all --configured \
          ${pkgs.my-kitty-colors}/"$term_background"-colors.conf &
      end
    '';
    onVariable = "term_background";
  };
  programs.fish.interactiveShellInit = lib.mkIf config.programs.kitty.enable ''
    # Run function to set Kitty colors based on `$term_background`, and to register them so they are
    # triggerd when the relevent event happens or variable changes.
    set-term-colors
  '';

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.showProgramPath = true;

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;
  # }}}

  # Other packages ----------------------------------------------------------------------------- {{{

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
    procs # fancy version of `ps`
    ripgrep # better version of `grep`
    tealdeer # rust implementation of `tldr`
    unrar # extract RAR archives
    wget
    xz # extract XZ archives

    # Dev stuff
    (agda.withPackages (p: [ p.standard-library ]))
    cloc # source code line counter
    google-cloud-sdk
    haskell-language-server
    haskellPackages.cabal-install
    haskellPackages.hoogle
    haskellPackages.hpack
    haskellPackages.implicit-hie
    haskellPackages.stack
    idris2
    jq
    nodePackages.typescript
    nodejs
    (python3.withPackages (p: with p; [ mypy pylint yapf ]))
    s3cmd
    tickgit

    # Useful nix related tools
    cachix # adding/managing alternative binary caches hosted by Cachix
    comma # run software from without installing it
    lorri # improve `nix-shell` experience in combination with `direnv`
    niv # easy dependency management for nix projects
    nodePackages.node2nix

  ] ++ lib.optionals stdenv.isDarwin [
    m-cli # useful macOS CLI commands
    # mypkgs.prefmanager # tool for working with macOS defaults
  ];
  # }}}

  # This value determines the Home Manager release that your configuration is compatible with. This
  # helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See the Home Manager release notes for
  # a list of state version changes in each release.
  home.stateVersion = "21.03";
}
# vim: foldmethod=marker
