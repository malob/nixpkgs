{ config, pkgs, lib, ... }:
# Let-In ----------------------------------------------------------------------------------------{{{
let
  inherit (lib) optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;

  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });

  nonVSCodePluginWithConfig = plugin: {
    inherit plugin;
    optional = true;
    config = ''
      if !exists('g:vscode')
        lua require('malo.' .. string.gsub('${plugin.pname}', '%.', '-'))
      endif
    '';
  };

  nonVSCodePlugin = plugin: {
    inherit plugin;
    optional = true;
    config = ''
      if !exists('g:vscode') | packadd ${plugin.pname} | endif
    '';
  };
in
# }}}
{
  # Neovim
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim.enable = true;

  # Config and plugins ------------------------------------------------------------------------- {{{

  # Minimal init.vim config to load Lua config. Nix and Home Manager don't currently support
  # `init.lua`.
  xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/lua";
  xdg.configFile."nvim/colors".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/colors";
  programs.neovim.extraConfig = "lua require('init')";

  programs.neovim.extraLuaPackages = [ pkgs.lua51Packages.penlight ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    lush-nvim
    tabular
    vim-commentary
    vim-eunuch
    vim-haskell-module-name
    vim-surround
  ] ++ map (p: { plugin = p; optional = true; }) [
    which-key-nvim
    zoomwintab-vim
  ] ++ map nonVSCodePlugin [
    agda-vim
    copilot-vim
    direnv-vim
    goyo-vim
    vim-fugitive
  ] ++ map nonVSCodePluginWithConfig [
    (pluginWithDeps coq_nvim [ coq-artifacts coq-thirdparty ])
    editorconfig-vim
    (pluginWithDeps galaxyline-nvim [ nvim-web-devicons ])
    gitsigns-nvim
    indent-blankline-nvim
    lspsaga-nvim
    (pluginWithDeps bufferline-nvim [ nvim-web-devicons ])
    null-ls-nvim
    nvim-lastplace
    nvim-lspconfig
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    (pluginWithDeps telescope-nvim [
      nvim-web-devicons
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-symbols-nvim
      telescope-zoxide
    ])
    toggleterm-nvim
    vim-pencil
    vim-polyglot
  ];

  # From personal addon module `../modules/home/programs/neovim/extras.nix`
  programs.neovim.extras.termBufferAutoChangeDir = true;
  programs.neovim.extras.nvrAliases.enable = true;
  # }}}

  # Required packages -------------------------------------------------------------------------- {{{

  programs.neovim.extraPackages = with pkgs; [
    neovim-remote

    # Language servers, linters, etc.
    # See `../configs/nvim/lua/malo/nvim-lspconfig.lua` and
    # `../configs/nvim/lua/malo/null-ls-nvim.lua` for configuration.

    # C/C++/Objective-C
    ccls

    # Bash
    nodePackages.bash-language-server
    shellcheck

    # Javascript/Typescript
    nodePackages.typescript-language-server

    # Nix
    deadnix
    statix
    rnix-lsp

    # Python
    black
    isort
    pylint
    pyright
    python3Packages.vulture

    # Vim
    nodePackages.vim-language-server

    #Other
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    proselint
    sumneko-lua-language-server
  ];
  # }}}
}
# vim: foldmethod=marker
