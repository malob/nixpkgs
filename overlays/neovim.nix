self: super: {
  neovim = super.neovim.override {
    configure = {
      customRC = builtins.readFile ./init.vim;
      packages.myVimPackages = with (import ~/.nix-defexpr/channels/nixos-unstable {}).pkgs.vimPlugins; {
        start = [
          airline
          ale
          denite
          deoplete-nvim
          gitgutter
          goyo-vim
          haskell-vim
          LanguageClient-neovim
          neco-vim
          tabular
          vim-airline-themes
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
