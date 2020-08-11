self: super:
let
  sources = import ../nix/sources.nix;

  customVimPlugins = with super.vimUtils; {
    vim-haskell-module-name = buildVimPluginFrom2Nix {
      name = "vim-haskell-module-name";
      src  = sources.vim-haskell-module-name;
    };
  };
in {
  myNeovim = self.pkgs.neovim.override {
    configure = {
      customRC = ''
        source $HOME/.config/nixpkgs/configs/nvim/init.vim
      '';
      packages.myVimPackages = with self.pkgs.unstable.vimPlugins // customVimPlugins; {
        start = [
          # UI plugins
          airline
          NeoSolarized
          vim-airline-themes
          vim-choosewin
          vim-devicons
          vim-startify

          # Coc.nvim plugins
          coc-nvim
          coc-eslint
          coc-git
          coc-json
          coc-lists
          coc-python
          coc-snippets
          coc-tabnine
          coc-tsserver
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
          vim-haskell-module-name
          vim-pencil
          vim-polyglot
          vim-surround
        ];
      };
    };
  };

  nvr-edit = super.writeShellScriptBin "n" ''
    if test -n "$NVIM_LISTEN_ADDRESS"; then
      ${super.pkgs.neovim-remote}/bin/nvr $@
    else
      nvim $@
    fi
  '';

  nvr-split = super.writeShellScriptBin "nh" ''
    if test -n "$NVIM_LISTEN_ADDRESS"; then
      ${super.pkgs.neovim-remote}/bin/nvr -o $@
    else
      echo "Not in Neovim"
      exit 1
    fi
  '';

  nvr-vsplit = super.writeShellScriptBin "nv" ''
    if test -n "$NVIM_LISTEN_ADDRESS"; then
      ${super.pkgs.neovim-remote}/bin/nvr -O $@
    else
      echo "Not in Neovim"
      exit 1
    fi
  '';

  nvr-tab = super.writeShellScriptBin "nt" ''
    if test -n "$NVIM_LISTEN_ADDRESS"; then
      ${super.pkgs.neovim-remote}/bin/nvr --remote-tab $@
    else
      echo "Not in Neovim"
      exit 1
    fi
  '';

  myNeovimEnv = super.buildEnv {
    name = "NeovimEnv";
    paths = with self.pkgs; [
      myNeovim
      neovim-remote

      nvr-edit
      nvr-split
      nvr-vsplit
      nvr-tab
    ];
  };
}
