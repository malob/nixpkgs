self: super:
{
  myGems = super.pkgs.callPackage ../pkgs/ruby-gems {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};
  myPythonPackages = import ../pkgs/python-packages/requirements.nix {};

  myCommonEnv = self.buildEnv {
    name = "CommonEnv";
    paths = with self.pkgs; [
      # Some basics
      bundix
      coreutils
      unstable.ccls
      curl
      gitAndTools.hub
      google-cloud-sdk
      htop
      lua
      mosh
      myGems.vimgolf
      neovim-remote
      nodejs
      nodePackages.node2nix
      parallel
      pypi2nix
      ripgrep
      s3cmd
      myNodePackages.speed-test
      unstable.nodePackages.typescript
      thefuck
      tldr
      unrar
      wget
      xz

      # My wrapped and config derivations
      myBat
      myGit
      myKitty
      myNeovim

      # Haskell development tools
      # haskellPackages.brittany
      haskellPackages.hoogle
      haskellPackages.weeder
      hie.hie86
      hyperfine
      stack

      # Neovim dependencies for linters and languages servers
      luaPackages.luacheck
      myNodePackages.bash-language-server
      myNodePackages.typescript-language-server
      vim-vint
    ];
  };
}
