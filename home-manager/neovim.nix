{ config, pkgs, lib, sources, ... }:

# Let-In --------------------------------------------------------------------------------------- {{{
let
  # Function to create Nix Neovim plugins derivations that aren't currently in `nixpkgs`. Source for
  # plugins are managed using flakes, see `../flake.nix`.
  buildVimPluginFromFlakeSource = name:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = name;
      src = sources.${name};
    };

  # Function to create Nix Neovim plugins from Lua pacakges.
  buildNeovimPluginFromLuaPackage = name: src:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = name;
      src = pkgs.linkFarm name [ { name = "lua"; path = src; } ];
    };

  nvr = "${pkgs.neovim-remote}/bin/nvr";
in
# }}}
{
  # Neovim
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim.enable = true;

  # Use Neovim nightly (0.5.0) package provided by Nix Flake in Neovim repo, and made available via
  # an overlay, see `../flake.nix`.
  programs.neovim.package = pkgs.neovim-nightly;

  # Config and plugins ------------------------------------------------------------------------- {{{

  programs.neovim.configure = {

    # Minimal init.vim config to load Lua config. Nix and Home Manager don't currently support
    # `init.lua`.
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
  # }}}

  # Related shell config ----------------------------------------------------------------------- {{{

  programs.fish.functions = lib.mkIf config.programs.neovim.enable {
    # See `../configs/nvim/lua/init.lua for related Neovim configuration.
    nvim-term-change-dir = {
      body = ''
        # Change dir of term buffer in Neovim to match `$PWD` of shell.
        if test -n "$NVIM_LISTEN_ADDRESS"
          ${nvr} -c "lua TermPwd['$fish_pid'] = '$PWD'" -c "lua SetTermPwd()"
        end
      '';
      onVariable = "PWD";
    };

    # See `./shells.nix` for more on how this is used.
    set-nvim-background = {
      body = ''
        # Set `background` of all running Neovim instances base on `$term_background`.
        for server in (${nvr} --serverlist)
          ${nvr} -s --nostart --servername $server -c "set background=$term_background" &
        end
      '';
      onVariable = "term_background";
    };
  };

  programs.fish.interactiveShellInit = lib.mkIf config.programs.neovim.enable ''
    # Run Neovim related functions on init for their effects, and to register them so they are
    # triggered when the relevant event happens or variable changes.
    nvim-term-change-dir
    set-nvim-background

    # Neovim Remote aliases
    # Taken from https://github.com/Soares/config.fish/blob/f9a8b48dd042bc93e62d4765633e41b119279040/config.fish#L18-L27
    # Not defined in `programs.fish.shellAliases` because of need to test for environment variable.
    if test -n "$NVIM_LISTEN_ADDRESS"
      alias nh "${nvr} -o"
      alias nv "${nvr} -O"
      alias nt "${nvr} --remote-tab"
      alias n  "${nvr}"
      alias neovim 'command nvim'
      alias nvim "echo 'You\'re already in nvim. Consider using n, h, v, or t instead. Use \'neovim\' to force.'"
      alias floaterm "${pkgs.vimPlugins.vim-floaterm}/share/vim-plugins/vim-floaterm/bin/floaterm"
    else
      alias n 'nvim'
    end
  '';
  # }}}

  # Required packages -------------------------------------------------------------------------- {{{

  home.packages = with pkgs; [
    neovim-remote
    tabnine

    # Language servers
    # See `../configs/nvim/lua/init.lua` for configuration.
    ccls
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
    rnix-lsp
  ];
  # }}}
}
# vim: foldmethod=marker
