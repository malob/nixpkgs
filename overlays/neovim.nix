self: super:
let
  # Get sha256 by running nix-prefetch-url --unpack https://github.com/[owner]/[name]/archive/[rev].tar.gz
  customVimPlugins = with super.vimUtils; {
    deoplete-fish = buildVimPluginFrom2Nix {
      name = "deoplete-fish";
      src = super.fetchFromGitHub {
        owner = "ponko2";
        repo = "deoplete-fish";
        rev = "9b9a686186e6484163b34eb6e620b83be355e82c";
        sha256 = "1v7ay0isrgcz0hgyggdqvmrldz0in26prj7p9l8ygkyrjq2w6b8a";
      };
    };
    NeoSolarized = buildVimPluginFrom2Nix {
      name = "NeoSolarized";
      src = super.fetchFromGitHub {
        owner = "icymind";
        repo = "NeoSolarized";
        rev = "1af4bf6835f0fbf156c6391dc228cae6ea967053";
        sha256 = "1l98yh3438anq33a094p5qrnhcm60nr28crs0v4nfah7lfdy5mc2";
      };
    };
    vim-choosewin = buildVimPluginFrom2Nix {
      name = "choosewin";
      src = super.fetchFromGitHub {
        owner = "t9md";
        repo = "vim-choosewin";
        rev = "4ac141a9bb7188ebbbff90bb0a0bccd52eaa83f8";
        sha256 = "08glj4fk4jlcdqbyd77dwy3rbn3vc0fqz077fwvkxym47hfg9rqk";
      };
    };
    vim-fish = buildVimPluginFrom2Nix {
      name = "vim-fish";
      src = super.fetchFromGitHub {
        owner = "dag";
        repo = "vim-fish";
        rev = "50b95cbbcd09c046121367d49039710e9dc9c15f";
        sha256 = "1yvjlm90alc4zsdsppkmsja33wsgm2q6kkn9dxn6xqwnq4jw5s7h";
      };
    };
  };
in {
  myNeovim = self.pkgs.unstable.neovim.override {
    configure = {
      customRC = builtins.readFile ./neovim-config.vim;
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
          vim-fish
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
