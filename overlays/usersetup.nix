self: super:
{
  hie = super.pkgs.callPackage ../pkgs/hie-nix {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};

  usersetup = self.buildEnv {
    name = "UserSetup";
    paths = with self.pkgs; [
      # Some basics
      bat
      hie.hies
      kitty
      neovim
      neovim-remote
      thefuck
      tldr
      myNodePackages.typescript

      # Neovim dependencies for linters and languages servers
      luaPackages.luacheck
      myNodePackages.bash-language-server
      myNodePackages.typescript-language-server
      vim-vint
    ];
  };
}
