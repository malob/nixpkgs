self: super:
let
  # Get sha256 by running nix-prefetch-url --unpack https://github.com/[owner]/[name]/archive/[rev].tar.gz
  customVimPlugins = with super.vimUtils; {
  #  package-name-here = buildVimPluginFrom2Nix {
  #    name = "";
  #    src = super.fetchFromGitHub {
  #      owner = "";
  #      repo = "";
  #      rev = "";
  #      sha256 = "";
  #    };
  #  };
  };

in {
  myNeovim = self.pkgs.unstable.neovim.override {
    configure = {
      customRC = builtins.readFile ./neovim-config.vim;
      packages.myVimPackages = with self.pkgs.unstable.vimPlugins // customVimPlugins; {
        start = [
          airline
          ale
          denite
          deoplete-fish
          deoplete-nvim
          gitgutter
          goyo-vim
          LanguageClient-neovim
          neco-vim
          NeoSolarized
          tabular
          vim-airline-themes
          vim-choosewin
          vim-commentary
          vim-fugitive
          vim-pencil
          vim-polyglot
          vim-startify
          vim-surround
          yats-vim
        ];
      };
    };
  };
}
