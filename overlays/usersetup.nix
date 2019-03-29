self: super:
{
  hie = super.pkgs.callPackage ../pkgs/hie-nix {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};
  usersetup = self.buildEnv {
    name = "UserSetup";
    paths = with self.pkgs; [
      bat
      kitty
      neovim
      neovim-remote
      tldr
      hie.hies
      myNodePackages.bash-language-server
      myNodePackages.typescript
      myNodePackages.typescript-language-server
    ];
  };
}
