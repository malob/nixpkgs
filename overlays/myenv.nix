self: super:
let
  OS =
    if super.stdenv.isDarwin then
      "macOS"
    else
      builtins.elemAt (builtins.match "NAME=\"?([A-z]+)\"?.*" (builtins.readFile /etc/os-release)) 0;
in{
  myEnv = super.buildEnv {
    name  = "myEnv";
    paths = with self.pkgs; [
      # Some basics
      browsh                    # in terminal browser
      coreutils
      cloc                      # source code line counter
      curl
      fd                        # substitute for `find`
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
      unstable.ytop             # fancy version of `top` with ASCII graphs

      # My wrapped and config derivations
      myBat       # a better version of `cat`
      myGitEnv    # includes diff-so-fancy and hub
      myNeovimEnv # includes neovim-remote

      # General dev stuff
      myAgdaEnv
      myIdrisEnv
      myHaskellEnv
      myPythonEnv
      unstable.nodePackages.bash-language-server
      unstable.ccls
      unstable.google-cloud-sdk
      myTickgit
      nodejs
      unstable.nodePackages.typescript
      unstable.rnix-lsp
      s3cmd
      watchman

      # Useful nix related tools
      unstable.any-nix-shell # add support for nix-shell in fish
      cachix                 # adding/managing atternative binary caches hosted by Cachix
      unstable.niv

      # My custom nix related shell scripts
      myenv-script
      terminal-colors-dark
      terminal-colors-light
    ]
    # OS specific packages to include (I only use Ubuntu for non-GUI VMs)
    ++ lib.optionals (OS != "Ubuntu") [
      myKitty
    ]
    ++ lib.optionals (OS == "Ubuntu") [
      unstable.abduco
      unstable.direnv
      unstable.lorri
      unstable.nixFlakes
      unstable.fish-foreign-env # needed for Fish shell
    ]
    ++ lib.optionals (OS == "NixOS") [
      slack
      vscode
    ];
  };
}
