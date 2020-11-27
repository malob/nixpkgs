# Some useful nix functionality
self: super: {
  mylib = {
    OS =
      if super.stdenv.isDarwin then
        "macOS"
      else
        builtins.elemAt (builtins.match "NAME=\"?([A-z]+)\"?.*" (builtins.readFile /etc/os-release)) 0;
    nodePackage2VimPackage = name: super.pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = name;
      inherit (self.mypkgs.nodePackages.${name}) version meta;
      src = "${self.mypkgs.nodePackages.${name}}/lib/node_modules/${name}";
    };
  };
}
