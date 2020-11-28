{ pkgs, ... }:

let
  sources = import ../nix/sources.nix;

  customVimPlugins = with pkgs.vimUtils // pkgs.mylib; {
    vim-haskell-module-name = buildVimPluginFrom2Nix {
      name = "vim-haskell-module-name";
      src = sources.vim-haskell-module-name;
    };
    coc-fish = nodePackage2VimPackage "coc-fish";
    coc-import-cost = nodePackage2VimPackage "coc-import-cost";
    coc-sh = nodePackage2VimPackage "coc-sh";
  };
in
{

  programs.neovim.enable = true;

  # Source config from out of nix store so that it's easy to edit on the fly
  programs.neovim.extraConfig = ''
    source $HOME/.config/nixpkgs/configs/nvim/init.vim
  '';

  # Plugins
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # UI plugins
    airline
    NeoSolarized
    vim-airline-themes
    vim-clap
    vim-choosewin
    vim-devicons
    vim-floaterm
    vim-startify
    zoomwintab-vim

    # Coc.nvim plugins
    coc-nvim
    coc-eslint
    customVimPlugins.coc-fish
    coc-git
    customVimPlugins.coc-import-cost
    coc-json
    coc-lists
    coc-markdownlint
    coc-python
    customVimPlugins.coc-sh
    coc-snippets
    coc-tabnine
    coc-tsserver
    coc-vimlsp
    coc-yaml
    coc-yank

    # other plugins
    agda-vim
    ale
    direnv-vim
    editorconfig-vim
    goyo-vim
    tabular
    vim-commentary
    vim-eunuch
    vim-fugitive
    customVimPlugins.vim-haskell-module-name
    vim-pencil
    vim-polyglot
    vim-surround
  ];

  # Add `nvr` command to environment
  home.packages = [
    pkgs.neovim-remote
  ];
}
