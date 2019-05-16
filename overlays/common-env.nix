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
      gitAndTools.hub
      google-cloud-sdk
      gotop
      htop
      loc
      lua
      mosh
      neovim-remote
      nodejs
      parallel
      ripgrep
      s3cmd
      myNodePackages.speed-test
      unstable.nodePackages.typescript
      thefuck
      tldr
      unrar
      wget
      xz

      # Useful nix related tools
      bundix
      cachix
      nixops
      nodePackages.node2nix
      pypi2nix

      # My wrapped and config derivations
      myBat
      myGit
      myKitty
      myNeovim

      # Haskell development tools
      cabal-install
      haskellPackages.ghcid
      haskellPackages.hoogle
      haskellPackages.weeder
      all-hies.latest
      hyperfine
      stack

      # Neovim dependencies for linters and languages servers
      unstable.ccls
      luaPackages.luacheck
      myNodePackages.bash-language-server
      myNodePackages.typescript-language-server
      vim-vint
    ];
  };
}
