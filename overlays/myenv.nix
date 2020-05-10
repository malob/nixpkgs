self: super:
let
  OS = builtins.elemAt (builtins.match "NAME=\"?([A-z]+)\"?.*" (builtins.readFile /etc/os-release)) 0;
in{
  myEnv = super.buildEnv {
    name  = "Env";
    paths = with self.pkgs; [
      # Some basics
      browsh                    # in terminal browser
      coreutils
      cloc                      # source code line counter
      curl
      fd                        # substitute for `find`
      unstable.fish-foreign-env # needed for fish-shell for non-NixOS installations
      gotop                     # fancy version of `top` with ASCII graphs
      htop                      # fancy version of `top`
      hyperfine                 # benchmarking tool
      mosh                      # wrapper for `ssh` that better and not dropping connections
      parallel                  # runs commands in parallel
      ripgrep                   # better version of grep
      nodePackages.speed-test
      unstable.starship         # fast, customizable prompt for any shell
      thefuck                   # suggests fixes to commands that exit with a non-zero status
      tldr                      # simple man pages, mostly examples of how to use commands
      unrar                     # extract RAR archives
      wget
      xz                        # extract XZ archives

      # My wrapped and config derivations
      myBat       # a better version of `cat`
      myGitEnv    # includes diff-so-fancy and hub
      myNeovimEnv # includes neovim-remote

      # General dev stuff
      myIdris
      myHaskellEnv
      myPythonEnv
      myPureScriptEnv
      unstable.nodePackages.bash-language-server
      unstable.ccls
      unstable.google-cloud-sdk
      unstable.nodePackages.typescript
      s3cmd
      nodejs
      watchman

      # Useful nix related tools
      unstable.any-nix-shell # add support for nix-shell in fish
      cachix                 # adding/managing atternative binary caches hosted by Cachix

      # My custom nix related shell scripts
      myenv-script
    ]
    # Because on NixOS Fish gets installed at the system level
    ++ lib.optionals (OS != "NixOS") [
      fish
    ]
    # Because I only use Ubuntu for cloud VMs
    ++ lib.optionals (OS != "Ubuntu") [
      myKittyEnv
    ]
    ++ lib.optionals super.stdenv.isDarwin [
      m-cli             # useful macOS cli commands
      terminal-notifier # notifications when terminal commands finish running
      myGems.vimgolf    # fun Vim puzzels
    ]
    ++ lib.optionals (OS == "Ubuntu") [
      unstable.abduco
    ]
    ++ lib.optionals (OS == "NixOS") [
      slack
      vscode
    ];
  };
}
