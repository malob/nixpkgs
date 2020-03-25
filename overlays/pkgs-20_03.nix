self: super: {
  release-beta = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/tarball/release-20.03";
  }) {};
}
