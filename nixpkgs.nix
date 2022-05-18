{ system ? builtins.currentSystem, ... }@args: import (import ./default.nix).inputs.nixpkgs-unstable args
