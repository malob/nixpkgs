self: super: {
  myGems = super.pkgs.callPackage ../pkgs/ruby-gems {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};
  myPythonPackages = import ../pkgs/python-packages/requirements.nix {};

  myCommonEnv = self.buildEnv {
    name = "CommonEnv";
    paths = with self.pkgs; [
      # Some basics
      browsh
      coreutils
      cloc
      curl
      fd
      fish-foreign-env
      gotop
      htop
      hyperfine
      mosh
      parallel
      ripgrep
      s3cmd
      unstable.nodePackages.speed-test
      thefuck
      tldr
      unrar
      wget
      xz

      # My wrapped and config derivations
      myBat
      myGitEnv # includes diff-so-fancy and hub
      myKitty
      myNeovimEnv # includes neovim-remote

      # Useful nix related tools
      bundix
      cachix
      nixops
      unstable.nodePackages.node2nix
      pypi2nix

      # My custom nix related shell scripts
      nixuser-rebuild
      nixuser-update-sources
      nix-cleanup-store

      # Haskell stuff
      (all-hies.unstableFallback.selection { selector = p: { inherit (p) ghc881 ghc865 ghc864; }; })
      unstable.cabal-install
      haskellPackages.hoogle
      haskellPackages.hpack
      unstable.stack

      # Other dev stuff
      unstable.ccls
      google-cloud-sdk
      lua53Packages.lua
      unstable.lua53Packages.luacheck
      ninja
      nodejs
      unstable.nodePackages.serverless
      unstable.nodePackages.bash-language-server
      unstable.nodePackages.typescript
      vim-vint
      watchman
      yarn
    ];
  };
}
