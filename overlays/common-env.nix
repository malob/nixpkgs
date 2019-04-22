self: super:
{
  hie = super.pkgs.callPackage ../pkgs/hie-nix {};
  myGems = super.pkgs.callPackage ../pkgs/ruby-gems {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};

  myCommonEnv = self.buildEnv {
    name = "CommonEnv";
    paths = with self.pkgs; [
      # Some basics
      bundix
      coreutils
      curl
      gitAndTools.hub
      google-cloud-sdk
      htop
      lua
      mosh
      myGems.vimgolf
      myNodePackages.speed-test
      myNodePackages.typescript
      neovim-remote
      nodejs
      nodePackages.node2nix
      parallel
      ripgrep
      s3cmd
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
      myNodePackages.yaml-language-server
      vim-vint
    ];
  };
}
