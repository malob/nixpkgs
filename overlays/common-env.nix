self: super: {

  # Update custom packages
  nixuser-update-mypkgs = super.writeShellScriptBin "nixuser-update-mypkgs" ''
    pushd ~/.config/nixpkgs/pkgs/node-packages
    printf "\nUpdating Node package nix expressions ...\n"
    ${self.pkgs.unstable.nodePackages.node2nix}/bin/node2nix --nodejs-10 -i node-packages.json
    popd
    pushd ~/.config/nixpkgs/pkgs/ruby-gems/
    printf "\nUpdating Ruby Gems nix expressions ...\n"
    ${super.pkgs.bundix}/bin/bundix --magic
    popd
    pushd ~/.config/nixpkgs/pkgs/python-packages
    printf "\nUpdating Python package nix expressions ...\n"
    ${super.pkgs.unstable.pypi2nix}/bin/pypi2nix --python-version python36 --requirements requirements.txt
    popd
  '';

  # Collect garbage, optimize store, repair paths
  nix-cleanup-store = super.writeShellScriptBin "nix-cleanup" ''
    nix-collect-garbage -d
    nix optimise-store 2>&1 | sed -E 's/.*'\'''(\/nix\/store\/[^\/]*).*'\'''/\1/g' | uniq | sudo ${super.pkgs.parallel}/bin/parallel 'nix-store --repair-path {}'
  '';

  myCommonEnv = super.buildEnv {
    name = "CommonEnv";
    paths = with self.pkgs; [
      # Some basics
      browsh
      coreutils
      cloc
      curl
      fd
      fish-foreign-env
      gotop
      htop
      hyperfine
      mosh
      parallel
      ripgrep
      s3cmd
      unstable.nodePackages.speed-test
      thefuck
      tldr
      unrar
      wget
      xz

      # My wrapped and config derivations
      myBat
      myGitEnv # includes diff-so-fancy and hub
      myKitty
      myNeovimEnv # includes neovim-remote

      # Useful nix related tools
      bundix
      cachix
      unstable.nodePackages.node2nix
      unstable.pypi2nix

      # My custom nix related shell scripts
      nixuser-update-mypkgs
      nix-cleanup-store

      # Haskell stuff
      (all-hies.unstableFallback.selection { selector = p: { inherit (p) ghc882 ghc881 ghc865; }; })
      unstable.cabal-install
      haskellPackages.hoogle
      haskellPackages.hpack
      unstable.stack

      # Other dev stuff
      unstable.ccls
      google-cloud-sdk
      lua53Packages.lua
      unstable.lua53Packages.luacheck
      ninja
      nodejs-12_x
      myPythonPackages.packages.scan-build
      unstable.nodePackages.serverless
      unstable.nodePackages.bash-language-server
      unstable.nodePackages.typescript
      vim-vint
      watchman
      yarn
    ];
  };
}
