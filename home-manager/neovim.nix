{ pkgs, lib, sources, ... }:

let
  # Functions to create Nix (neo)vim plugins that aren't currently in `nixpkgs`.
  # Source for plugins are managed using Nix Flakes, and are made available via an overlay.
  # See: ../flake.nix.
  buildVimPluginFromFlakeSource = name:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = name;
      src = sources.${name};
    };

  buildNeovimPluginFromLuaPackage = name: src:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = name;
      src = pkgs.linkFarm name [ { name = "lua"; path = src; } ];
    };
in
{
  programs.neovim.enable = true;

  # Use Neovim nightly (0.5.0) package provided by Nix Flake in Neovim repo, and made available via
  # an overlay. See: ../flake.nix
  programs.neovim.package = pkgs.neovim-nightly;

  programs.neovim.configure = {

    # Mininal init.vim config to load Lua config.
    customRC = ''
      " Add my configs to Neovim runtime path
      exe 'set rtp+=' . expand('~/.config/nixpkgs/configs/nvim')
      " Load Neovim configuration from ~/.config/nixpkgs/configs/nvim/lua/init.lua
      lua require('init')
    '';

    packages.myVimPackage = with pkgs.vimPlugins; {

      # Loaded on launch
      start = [
        agda-vim
        direnv-vim
        editorconfig-vim
        goyo-vim
        nvim-lspconfig
        nvim-treesitter
        nvim-web-devicons
        plenary-nvim # required for telescope-nvim and gitsigns.nvim
        popup-nvim # required for telescope-nvim
        tabular
        vim-commentary
        vim-eunuch
        vim-fugitive
        vim-polyglot
        vim-surround
        (buildNeovimPluginFromLuaPackage "moses-nvim" sources.moses-lua)
      ] ++ map buildVimPluginFromFlakeSource [
        "lush-nvim"
        "vim-haskell-module-name"
      ];

      # Manually loadable by calling `:packadd $plugin-name`
      opt = [
        completion-buffers
        completion-nvim
        completion-tabnine
        barbar-nvim
        vim-floaterm
        vim-pencil
        vim-which-key
        zoomwintab-vim
      ] ++ map buildVimPluginFromFlakeSource [
        "galaxyline-nvim"
        "gitsigns-nvim"
        "telescope-nvim"
      ];
    };
  };

  # Packages relevant to Neovim
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
