{ pkgs, ... }:

let
  myPlugins = with pkgs.vimUtils // pkgs.mylib; {
    vim-haskell-module-name = buildVimPluginFrom2Nix {
      name = "vim-haskell-module-name";
      src = pkgs.mySources.vim-haskell-module-name;
    };
    galaxyline-nvim = buildVimPluginFrom2Nix {
      name = "galaxyline-nvim";
      src = pkgs.mySources.galaxyline-nvim;
    };
    nvim-bufferline-lua = buildVimPluginFrom2Nix {
      name = "nvim-bufferline-lua";
      src = pkgs.mySources.nvim-bufferline-lua;
    };
    gitsigns-nvim = buildVimPluginFrom2Nix {
      name = "gitsigns-nvim";
      src = pkgs.mySources.gitsigns-nvim;
    };
    moses-nvim = buildVimPluginFrom2Nix {
      name = "moses-nvim";
      src = pkgs.linkFarm "moses-nvim" [ { name = "lua"; path = pkgs.mySources.moses-lua; } ];
    };
  };
in
{
  programs.neovim.enable = true;
  programs.neovim.package = pkgs.mypkgs.neovim-nightly;

  programs.neovim.configure = {

    # Source config from out of nix store so that it's easy to edit on the fly
    customRC = ''
      " Add my configs to Neovim runtime path
      exe 'set rtp+=' . expand('~/.config/nixpkgs/configs/nvim')
      lua require('init')
    '';

    packages.myVimPackage = with pkgs.vimPlugins; {

      # loaded on launch
      start = [
        agda-vim
        direnv-vim
        editorconfig-vim
        goyo-vim
        myPlugins.moses-nvim
        myPlugins.vim-haskell-module-name
        nvim-lspconfig
        nvim-web-devicons
        plenary-nvim # required for telescope-nvim and gitsigns.nvim
        popup-nvim # required for telescope-nvim
        tabular
        vim-commentary
        vim-eunuch
        vim-fugitive
        vim-polyglot
        vim-surround
      ];

      # manually loadable by calling `:packadd $plugin-name`
      opt = [
        NeoSolarized
        completion-buffers
        completion-nvim
        completion-tabnine
        myPlugins.galaxyline-nvim
        myPlugins.gitsigns-nvim
        myPlugins.nvim-bufferline-lua
        telescope-nvim
        vim-floaterm
        vim-pencil
        vim-which-key
        zoomwintab-vim
      ];
    };
  };

  home.packages = with pkgs; [
    neovim-remote
    tabnine

    # Language servers
    ccls
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
    rnix-lsp
  ];
}
