self: super:
let
  # Get sha256 by running nix-prefetch-url --unpack https://github.com/[owner]/[name]/archive/[rev].tar.gz
  customVimPlugins = with super.vimUtils; {
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
    # my-coc-nvim = buildVimPluginFrom2Nix rec {
    #   pname = "coc-nvim";
    #   version = "0.0.73";
    #   src = super.fetchFromGitHub {
    #     owner = "neoclide";
    #     repo = "coc.nvim";
    #     rev = "v${version}";
    #     sha256 = "1z7573rbh806nmkh75hr1kbhxr4jysv6k9x01fcyjfwricpa3cf7";
    #   };
    # };
  };
in {
  myNeovim = self.pkgs.unstable.neovim.override {
    configure = {
      customRC = ''
        source $HOME/.config/nixpkgs/configs/init.vim
      '';
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
          coc-nvim

          # other plugins
          ale
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
