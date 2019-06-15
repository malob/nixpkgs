self: super:
let
  # Get sha256 by running nix-prefetch-url --unpack https://github.com/[owner]/[name]/archive/[rev].tar.gz
  customVimPlugins = with super.vimUtils; {
    coc-denite = buildVimPluginFrom2Nix {
      name = "coc-denite";
      src = super.fetchFromGitHub {
        owner = "neoclide";
        repo = "coc-denite";
        rev = "ec7dfd5";
        sha256 = "0fc03ndq7ys4lvqgfbh314fsvbcjf3nm4spfklsmz2c587qbvv1l";
      };
    };
    NeoSolarized = buildVimPluginFrom2Nix {
      name = "NeoSolarized";
      src = super.fetchFromGitHub {
        owner = "malob";
        repo = "NeoSolarized";
        rev = "a8e6e52";
        sha256 = "0bxrm2vm3z1y37sm6m2hdn72g2sw31dx1xhmjvd0ng72cnp84d9k";
      };
    };
  };

in {
  myNeovim = self.pkgs.unstable.neovim.override {
    configure = {
      customRC = builtins.readFile ./neovim-config.vim;
      packages.myVimPackages = with self.pkgs.unstable.vimPlugins // customVimPlugins; {
        start = [

          # UI plugins
          airline
          NeoSolarized
          vim-airline-themes
          vim-choosewin
          vim-devicons
          vim-startify

          # other plugins
          ale
          coc-nvim
          coc-denite
          denite
          goyo-vim
          tabular
          vim-commentary
          vim-fugitive
          vim-pencil
          vim-polyglot
          vim-surround

          # old plugins

          # deoplete-fish
          # deoplete-nvim
          # LanguageClient-neovim
          # neco-vim
          # yats-vim
        ];
      };
    };
  };
}
