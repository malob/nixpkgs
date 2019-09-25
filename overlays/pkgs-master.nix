self: super: {
  master = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/tarball/master";
  }) {};
}
