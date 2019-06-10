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

in {
  myNeovim = self.pkgs.unstable.neovim.override {
    configure = {
      customRC = (builtins.readFile ./neovim-config.vim) + choosewinConfig;
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
