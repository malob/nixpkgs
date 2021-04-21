{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  nvr = "${pkgs.neovim-remote}/bin/nvr";
  withPluginDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });
in
{
  # Neovim
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim.enable = true;

  # Use Neovim nightly (0.5.0) package provided by Nix Flake in Neovim repo, and made available via
  # an overlay, see `../flake.nix`.
  programs.neovim.package = pkgs.neovim-nightly;

  # Config and plugins ------------------------------------------------------------------------- {{{

  # Minimal init.vim config to load Lua config. Nix and Home Manager don't currently support
  # `init.lua`.
  xdg.configFile."nvim/lua".source = ../configs/nvim/lua;
  xdg.configFile."nvim/colors".source = ../configs/nvim/colors;
  programs.neovim.extraConfig = "lua require('init')";

  programs.neovim.plugins = with pkgs.vimPlugins; [
    agda-vim
    direnv-vim
    editorconfig-vim
    goyo-vim
    lush-nvim
    moses-nvim
    (withPluginDeps nvim-bufferline-lua [ nvim-web-devicons ])
    nvim-lspconfig
    nvim-treesitter
    tabular
    vim-commentary
    vim-eunuch
    vim-fugitive
    vim-haskell-module-name
    vim-polyglot
    vim-surround
  ] ++ map (p: { plugin = p; optional = true; }) [
    completion-buffers
    completion-nvim
    completion-tabnine
    (withPluginDeps galaxyline-nvim [ nvim-web-devicons ])
    (withPluginDeps gitsigns-nvim [ plenary-nvim ])
    (withPluginDeps telescope-nvim [ nvim-web-devicons plenary-nvim popup-nvim ])
    telescope-symbols-nvim
    telescope-z-nvim
    vim-floaterm
    vim-pencil
    vim-which-key
    zoomwintab-vim
  ];
  # }}}

  # Shell related ------------------------------------------------------------------------------ {{{

  # From personal addon module `./modules/programs/neovim/extras.nix`
  programs.neovim.extras.termBufferAutoChangeDir = true;
  programs.neovim.extras.nvrAliases.enable = true;

  programs.fish.functions.set-nvim-background = mkIf config.programs.neovim.enable {
    # See `./shells.nix` for more on how this is used.
    body = ''
      # Set `background` of all running Neovim instances base on `$term_background`.
      for server in (${nvr} --serverlist)
        ${nvr} -s --nostart --servername $server -c "set background=$term_background" &
      end
    '';
    onVariable = "term_background";
  };

  programs.fish.interactiveShellInit = mkIf config.programs.neovim.enable ''
    # Run Neovim related functions on init for their effects, and to register them so they are
    # triggered when the relevant event happens or variable changes.
    set-nvim-background
  '';
  # }}}

  # Required packages -------------------------------------------------------------------------- {{{

  programs.neovim.extraPackages = with pkgs; [
    neovim-remote
    gcc # needed for nvim-treesitter
    tree-sitter # needed for nvim-treesitter

    # Language servers
    # See `../configs/nvim/lua/init.lua` for configuration.
    ccls
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
    rnix-lsp
  ] ++ lib.optional (!stdenv.isDarwin) sumneko-lua-language-server;
  # }}}
}
# vim: foldmethod=marker
