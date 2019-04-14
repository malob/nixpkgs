self: super:
{
  hie = super.pkgs.callPackage ../pkgs/hie-nix {};
  kiwix-tools = super.pkgs.callPackage ../pkgs/kiwix-tools {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};

  usersetup = self.buildEnv {
    name = "UserSetup";
    paths = with super.pkgs; [
      # Some basics
      (aspellWithDicts (dicts: [dicts.en]))
      ack
      kiwix-tools
      neovim-remote
      thefuck
      tldr
      myNodePackages.typescript

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
