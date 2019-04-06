self: super:
{
  hie = super.pkgs.callPackage ../pkgs/hie-nix {};
  kiwix-tools = super.pkgs.callPackage ../pkgs/kiwix-tools {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};

  usersetup = self.buildEnv {
    name = "UserSetup";
    paths = with super.pkgs; [
      # Some basics
      haskellPackages.hoogle
      hie.hies
      kiwix-tools
      neovim
      neovim-remote
      thefuck
      tldr
      myNodePackages.typescript

      # My wrapped and config derivations
      myBat
      myGit
      myKitty

      # Neovim dependencies for linters and languages servers
      luaPackages.luacheck
      myNodePackages.bash-language-server
      myNodePackages.typescript-language-server
      vim-vint
    ];
  };
}
