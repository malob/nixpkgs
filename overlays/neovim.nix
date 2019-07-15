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
    # Personal fork of NeoSolarized
    NeoSolarized = buildVimPluginFrom2Nix {
      name = "NeoSolarized";
      src = super.fetchFromGitHub {
        owner = "malob";
        repo = "NeoSolarized";
        rev = "a8e6e52";
        sha256 = "0bxrm2vm3z1y37sm6m2hdn72g2sw31dx1xhmjvd0ng72cnp84d9k";
      };
    };
    # Needed until PR lands in unstable channel
    my-coc-nvim = buildVimPluginFrom2Nix rec {
      pname = "coc-nvim";
      version = "0.0.73";
      src = super.fetchFromGitHub {
        owner = "neoclide";
        repo = "coc.nvim";
        rev = "v${version}";
        sha256 = "1z7573rbh806nmkh75hr1kbhxr4jysv6k9x01fcyjfwricpa3cf7";
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

          # coc.nvim related
          my-coc-nvim
          coc-denite

          # other plugins
          ale
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
