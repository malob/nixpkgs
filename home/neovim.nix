{ config, pkgs, lib, ... }:
# Let-In ----------------------------------------------------------------------------------------{{{
let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;

  mkLuaTableFromList = x: "{" + lib.concatMapStringsSep "," (y: "'${y}'") x + "}";
  mkNeovimAutocmd = { event, pattern, callback ? "" }: ''
    vim.api.nvim_create_autocmd(${mkLuaTableFromList event}, {
      pattern = ${mkLuaTableFromList pattern},
      callback = ${callback},
    })'';
  requireConf = p: "require 'malo.${builtins.replaceStrings [ "." ] [ "-" ] p.pname}'";

  # Function to create `programs.neovim.plugins` entries inspired by `packer.nvim`.
  packer =
    { use
      # Plugins that this plugin depends on.
    , deps ? [ ]
      # Used to manually specify that the plugin shouldn't be loaded at start up.
    , opt ? false
      # Whether to load the plugin when using VS Code with `vscode-neovim`.
    , vscode ? false
      # Code to run before the plugin is loaded.
    , setup ? ""
      # Code to run after the plugin is loaded.
    , config ? ""
      # The following all imply lazy-loading and imply `opt = true`.
      # `FileType`s which load the plugin.
    , ft ? [ ]
      # Autocommand events which load the plugin.
    , event ? [ ]
    }:
    let
      loadFunctionName = "load_${builtins.replaceStrings [ "." "-" ] [ "_" "_" ] use.pname}";
      autoload = !opt && vscode && ft == [ ] && event == [ ];
      configFinal =
        concatStringsSep "\n" (
          optional (!autoload && !opt) "vim.cmd 'packadd ${use.pname}'"
          ++ optional (config != "") config
        );
    in
    {
      plugin = use.overrideAttrs (old: {
        dependencies = lib.unique (old.dependencies or [ ] ++ deps);
      });
      optional = !autoload;
      type = "lua";
      config = if (setup == "" && configFinal == "") then null else
      (
        concatStringsSep "\n"
          (
            [ "\n-- ${use.pname or use.name}" ]
            ++ optional (setup != "") setup

            # If the plugin isn't always loaded at startup
            ++ optional (!autoload) (concatStringsSep "\n" (
              [ "local ${loadFunctionName} = function()" ]
              ++ optional (!vscode) "if vim.g.vscode == nil then"
              ++ [ configFinal ]
              ++ optional (!vscode) "end"
              ++ [ "end" ]
              ++ optional (ft == [ ] && event == [ ]) "${loadFunctionName}()"
              ++ optional (ft != [ ]) (mkNeovimAutocmd {
                event = [ "FileType" ];
                pattern = ft;
                callback = loadFunctionName;
              })
              ++ optional (event != [ ]) (mkNeovimAutocmd {
                inherit event;
                pattern = [ "*" ];
                callback = loadFunctionName;
              })
            ))

            # If the plugin is always loaded at startup
            ++ optional (autoload && configFinal != "") configFinal
          )
      );
    };
in
# }}}
{
  # Neovim
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim.enable = true;

  # Config and plugins ------------------------------------------------------------------------- {{{

  # Put neovim configuration located in this repository into place in a way that edits to the
  # configuration don't require rebuilding the `home-manager` environment to take effect.
  xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/lua";
  xdg.configFile."nvim/colors".source =
  mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/colors";

  # Load the `init` module from the above configs
  programs.neovim.extraConfig = "lua require('init')";

  # Add `penlight` Lua module package since I used in the above configs
  programs.neovim.extraLuaPackages = ps: [ ps.penlight ];

  # Add plugins using my `packer` function.
  programs.neovim.plugins = with pkgs.vimPlugins; map packer [
    # Apperance, interface, UI, etc.
    {
      use = bufferline-nvim;
      deps = [ nvim-web-devicons scope-nvim ];
      config = requireConf bufferline-nvim;
    }
    { use = galaxyline-nvim; deps = [ nvim-web-devicons ]; config = requireConf galaxyline-nvim; }
    { use = gitsigns-nvim; config = requireConf gitsigns-nvim; }
    { use = goyo-vim; }
    { use = indent-blankline-nvim; config = requireConf indent-blankline-nvim; }
    { use = lush-nvim; vscode = true; }
    {
      use = telescope-nvim;
      config = requireConf telescope-nvim;
      deps = [
        nvim-web-devicons
        telescope-file-browser-nvim
        telescope-fzf-native-nvim
        telescope_hoogle
        telescope-symbols-nvim
        telescope-zoxide
      ];
    }
    { use = toggleterm-nvim; config = requireConf toggleterm-nvim; }
    { use = zoomwintab-vim; opt = true; }

    # Completions
    { use = copilot-vim; }
    { use = coq_nvim; opt = true; deps = [ coq-artifacts coq-thirdparty ]; config = requireConf coq_nvim; }

    # Language servers, linters, etc.
    {
      use = lsp_lines-nvim;
      config = ''
        require'lsp_lines'.setup()
        vim.diagnostic.config({ virtual_lines = { only_current_line = true } })'';
    }
    { use = lspsaga-nvim; config = requireConf lspsaga-nvim; }
    { use = null-ls-nvim; config = requireConf null-ls-nvim; }
    {
      use = nvim-lspconfig;
      deps = [ haskell-tools-nvim neodev-nvim telescope-nvim ];
      config = requireConf nvim-lspconfig;
    }

    # Language support/utilities
    {
      use = cornelis;
      setup = ''
        vim.g.cornelis_use_global_binary = 1
        vim.g.cornelis_agda_prefix = '\\'
      '';
    }
    {
      use = nvim-treesitter.withAllGrammars;
      config = requireConf nvim-treesitter;
    }
    { use = vim-haskell-module-name; vscode = true; }
    { use = vim-polyglot; config = requireConf vim-polyglot; }

    # Editor behavior
    { use = comment-nvim; config = "require'comment'.setup()"; }
    { use = editorconfig-vim; setup = "vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }"; }
    { use = tabular; vscode = true; }
    { use = vim-surround; vscode = true; }
    { use = nvim-lastplace; config = "require'nvim-lastplace'.setup()"; }
    {
      use = vim-pencil;
      setup = "vim.g['pencil#wrapModeDefault'] = 'soft'";
      config = "vim.fn['pencil#init'](); vim.wo.spell = true";
      ft = [ "markdown" "text" ];
    }

    # Misc
    { use = direnv-vim; }
    { use = vim-eunuch; vscode = true; }
    { use = vim-fugitive; }
    { use = which-key-nvim; opt = true; }
  ];

  # From personal addon module `../modules/home/programs/neovim/extras.nix`
  programs.neovim.extras.termBufferAutoChangeDir = true;
  programs.neovim.extras.nvrAliases.enable = true;
  programs.neovim.extras.defaultEditor = true;

  # }}}

  # Required packages -------------------------------------------------------------------------- {{{

  programs.neovim.extraPackages = with pkgs; [
    neovim-remote

    # Language servers, linters, etc.
    # See `../configs/nvim/lua/malo/nvim-lspconfig.lua` and
    # `../configs/nvim/lua/malo/null-ls-nvim.lua` for configuration.

    # Bash
    nodePackages.bash-language-server
    shellcheck

    # Javascript/Typescript
    nodePackages.typescript-language-server

    # Nix
    deadnix
    statix
    nil
    nixpkgs-fmt

    # Vim
    nodePackages.vim-language-server

    #Other
    (agda.withPackages (p: [ p.standard-library ]))
    cornelis
    nodePackages.yaml-language-server
    proselint
    sumneko-lua-language-server
    vscode-langservers-extracted
  ];
  # }}}
}
# vim: foldmethod=marker
