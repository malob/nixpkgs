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
    my-coc-nvim = let
      version = "0.0.72";
      index_js = super.fetchzip {
        url = "https://github.com/neoclide/coc.nvim/releases/download/v${version}/coc.tar.gz";
        sha256 = "128wlbnpz4gwpfnmzry5k52d58fyp9nccha314ndfnr9xgd6r52y";
      };
    in buildVimPluginFrom2Nix {
      pname = "coc-nvim";
      version = "2019-07-05";
      src = super.fetchFromGitHub {
        owner = "neoclide";
        repo = "coc.nvim";
        rev = "eed5413bc65e2b2dd8297f4937ec0eea3c12256a";
        sha256 = "1hncsmr11z9kq0jkdkxrpf5sm31qz1dkc38az20dlfba8b8p7x1g";
      };
      postInstall = ''
        mkdir -p $out/share/vim-plugins/coc-nvim/build
        cp ${index_js}/index.js $out/share/vim-plugins/coc-nvim/build/
      '';
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
          my-coc-nvim
          coc-denite
          denite
          goyo-vim
          tabular
          vim-commentary
          vim-fugitive
          vim-pencil
          vim-polyglot
          vim-surround
          yats-vim
        ];
      };
    };
  };
}
