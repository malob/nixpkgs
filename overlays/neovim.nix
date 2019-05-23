self: super:
with import ../neo-solazired.nix; let
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
  choosewinConfig = ''

    " Style choosewin to fit in with NeoSolarized colorscheme
    let g:choosewin_color_label         = {'gui': ['#${green}' , '#${base3}', 'bold'], 'cterm': [2 , 15, 'bold']}
    let g:choosewin_color_label_current = {'gui': ['#${base00}', '#${base03}']       , 'cterm': [10, 8 ]}
    let g:choosewin_color_other         = {'gui': ['#${base00}', '#${base00}']       , 'cterm': [10, 10]}
    let g:choosewin_color_land          = {'gui': ['#${yellow}', '#${base03}']       , 'cterm': [3 , 8 ]}
  '';
  termColorsConfig = ''

    " NeoVim terminal uses bold as bright (colors 8-15) but I want bold to just be bold
    let g:terminal_color_0  = '#${base03}'
    let g:terminal_color_1  = '#${red}'
    let g:terminal_color_2  = '#${green}'
    let g:terminal_color_3  = '#${yellow}'
    let g:terminal_color_4  = '#${blue}'
    let g:terminal_color_5  = '#${magenta}'
    let g:terminal_color_6  = '#${cyan}'
    let g:terminal_color_7  = '#${base2}'
    let g:terminal_color_8  = g:terminal_color_0
    let g:terminal_color_9  = g:terminal_color_1
    let g:terminal_color_10 = g:terminal_color_2
    let g:terminal_color_11 = g:terminal_color_3
    let g:terminal_color_12 = g:terminal_color_4
    let g:terminal_color_13 = g:terminal_color_5
    let g:terminal_color_14 = g:terminal_color_6
    let g:terminal_color_15 = g:terminal_color_7
  '';
in {
  myNeovim = self.pkgs.unstable.neovim.override {
    configure = {
      customRC = (builtins.readFile ./neovim-config.vim) + choosewinConfig + termColorsConfig;
      packages.myVimPackages = with self.pkgs.unstable.vimPlugins // customVimPlugins; {
        start = [
          airline
          ale
          denite
          deoplete-fish
          deoplete-nvim
          gitgutter
          goyo-vim
          haskell-vim
          LanguageClient-neovim
          neco-vim
          NeoSolarized
          tabular
          vim-airline-themes
          vim-choosewin
          vim-commentary
          vim-fish
          vim-fugitive
          vim-javascript
          vim-markdown
          vim-nix
          vim-pencil
          vim-startify
          vim-surround
          yats-vim
        ];
      };
    };
  };
}
