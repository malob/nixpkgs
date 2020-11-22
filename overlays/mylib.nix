# Some useful nix functionality
self: super: {
  mylib = {
    OS =
      if super.stdenv.isDarwin then
        "macOS"
      else
        builtins.elemAt (builtins.match "NAME=\"?([A-z]+)\"?.*" (builtins.readFile /etc/os-release)) 0;
  };
}
