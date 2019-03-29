{ pkgs ? (import (import ./fetch-nixpkgs.nix) {}) }:

let
  hie84Pkgs = (import ./ghc-8.4.nix { inherit pkgs; }).override {
    overrides = self: super: {
      # https://github.com/input-output-hk/stack2nix/issues/103
      ghc-syb-utils = null;
      # GHC 8.4 core libs
      mtl = null;
      parsec = null;
      stm = null;
      text = null;
      Cabal = null;
    };
  };
  hie86Pkgs = (import ./ghc-8.6.nix { inherit pkgs; }).override {
    overrides = self: super: {
      # conditional flag set to false in stackage
      resolv = self.callPackage ./resolv.nix {};
      # https://github.com/input-output-hk/stack2nix/issues/103
      ghc-syb-utils = null;
      # GHC 8.6 core libs
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  libiserv = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;
    };
  };
  jse = pkgs.haskell.lib.justStaticExecutables;
in with pkgs; rec {
 stack2nix = pkgs.stack2nix;
 hies = runCommandNoCC "hies" {
   buildInputs = [ makeWrapper ];
 } ''
   mkdir -p $out/bin
   ln -s ${hie82}/bin/hie $out/bin/hie-8.2
   ln -s ${hie84}/bin/hie $out/bin/hie-8.4
   ln -s ${hie86}/bin/hie $out/bin/hie-8.6
   makeWrapper ${hie84}/bin/hie-wrapper $out/bin/hie-wrapper \
     --prefix PATH : $out/bin
 '';
 hie82 = jse (import ./ghc-8.2.nix { inherit pkgs; }).haskell-ide-engine;
 hie84 = jse hie84Pkgs.haskell-ide-engine;
 hie86 = jse hie86Pkgs.haskell-ide-engine;
}
