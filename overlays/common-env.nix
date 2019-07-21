self: super:
{
  myGems = super.pkgs.callPackage ../pkgs/ruby-gems {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};
  myPythonPackages = import ../pkgs/python-packages/requirements.nix {};

  myCommonEnv = self.buildEnv {
    name = "CommonEnv";
    paths = with self.pkgs; [
      # Some basics
      coreutils
      curl
      fish-foreign-env
      gotop
      htop
      hyperfine
      loc
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
      myGitEnv
      myKitty
      myNeovimEnv

      # Useful nix related tools
      bundix
      cachix
      nixops
      unstable.nodePackages.node2nix
      pypi2nix

      # Development tools
      cabal-install
      ghc
      google-cloud-sdk
      haskellPackages.hoogle
      haskellPackages.weeder
      lua
      nodejs
      myNodePackages.serverless
      stack
      unstable.nodePackages.typescript
      watchman
      yarn

      # Neovim dependencies for linters and languages servers
      (all-hies.selection { selector = p: { inherit (p) ghc865 ghc864 ghc863; }; })
      unstable.ccls
      luaPackages.luacheck
      unstable.nodePackages.bash-language-server
      vim-vint
    ];
  };
}
