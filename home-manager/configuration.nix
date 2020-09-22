{ pkgs, lib, ... }:

{
  # Import config broken out into files
  imports = [
    ./git.nix
    ./shells.nix
    ./neovim.nix
  ];


  ###########################
  # Configure misc packages #
  ###########################

  # Bat, a substitute for cat
  # https://github.com/sharkdp/bat
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
  };

  # Direnv, load and unload environment variables depending on the current directory
  # https://direnv.net
  programs.direnv.enable = true;

  # Kitty terminal
  # Configuration options defined in overlays: `../overlays/kitty-configs.nix`
  programs.kitty.enable = pkgs.mylib.OS != "Ubuntu";
  programs.kitty.settings = pkgs.my-kitty-config // pkgs.my-kitty-light-config;
  xdg.configFile."kitty/macos-launch-services-cmdline".text = "--listen-on unix:/tmp/mykitty";

  # Htop
  programs.htop.enable          = true;
  programs.htop.showProgramPath = true;

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  programs.zoxide.enable = true;


  #######################
  # Additional packages #
  #######################

  home.packages = with pkgs; [
    # Some basics
    bandwhich                 # display current network utilization by process
    browsh                    # in terminal browser
    coreutils
    cloc                      # source code line counter
    curl
    du-dust                   # fancy version of `du`
    exa                       # fancy version of `ls`
    fd                        # fancy version of `find`
    htop                      # fancy version of `top`
    hyperfine                 # benchmarking tool
    mosh                      # wrapper for `ssh` that better and not dropping connections
    parallel                  # runs commands in parallel
    procs                     # fancy version of `ps`
    ripgrep                   # better version of grep
    nodePackages.speed-test   # nice speed-test tool
    thefuck                   # suggests fixes to commands that exit with a non-zero status
    tealdeer                  # rust implementation of `tldr`
    unrar                     # extract RAR archives
    wget
    xz                        # extract XZ archives
    ytop                      # fancy version of `top` with ASCII graphs

    # General dev stuff
    myenvs.agda
    myenvs.haskell
    myenvs.idris
    myenvs.python
    nodePackages.bash-language-server
    ccls
    google-cloud-sdk
    mypkgs.tickgit
    nodejs
    nodePackages.typescript
    rnix-lsp
    s3cmd
    watchman

    # Useful nix related tools
    cachix # adding/managing atternative binary caches hosted by Cachix
    lorri  # improve `nix-shell` experience in combination with `direnv`
    niv    # easy dependency management for nix projects

    # My custom nix related shell scripts
    myenv-script

  ] ++ lib.optionals (mylib.OS == "macOS") [
    m-cli               # useful macOS cli commands
    # mypkgs.prefmanager  # tool for working with macOS defaults
    mypkgs.gems.vimgolf # fun Vim puzzels
  ] ++ lib.optionals (mylib.OS == "Ubuntu") [
    abduco
  ]
  ++ lib.optionals (mylib.OS == "NixOS") [
    slack
    vscode
  ];
}
