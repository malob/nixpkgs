self: super:
{
  usersetup = self.buildEnv {
    name = "UserSetup";
    paths = with self.pkgs; [
      bat
      kitty
      neovim
      neovim-remote
      tldr
      hie.hies
      node-packages.bash-language-server
      node-packages.typescript
      node-packages.typescript-language-server
    ];
  };
}
