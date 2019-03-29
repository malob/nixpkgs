self: super:
{
  hie = super.pkgs.callPackage ../pkgs/hie-nix {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};

  usersetup = self.buildEnv {
    name = "UserSetup";
    paths = with self.pkgs; [
      bat
      hie.hies
      kitty
      neovim
      neovim-remote
      tldr

      luaPackages.luacheck

      myNodePackages.bash-language-server
      myNodePackages.typescript
      myNodePackages.typescript-language-server
    ];
  };
}
