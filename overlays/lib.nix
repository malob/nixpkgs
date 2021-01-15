final: prev: {
  lib = prev.lib // rec {
    # Vim Plugin helpers
    buildVimPluginFromFlakeInput = inputs: name:
      prev.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = inputs.${name}.lastModifiedDate;
        src = inputs.${name};
      };

    buildNeovimLuaPackagePluginFromFlakeInput = inputs: name:
      buildNeovimLuaPackagePlugin {
        pname = name + "-nvim";
        version = inputs.${name}.lastModifiedDate;
        src = inputs.${name};
      };

    buildNeovimLuaPackagePlugin = { pname, src, version ? "HEAD" }:
      prev.vimUtils.buildVimPluginFrom2Nix {
        inherit pname version;
        src = prev.linkFarm pname [ { name = "lua"; path = src; } ];
      };

    # Other
    OS =
      if prev.stdenv.isDarwin then
        "macOS"
      else
        builtins.elemAt (builtins.match "NAME=\"?([A-z]+)\"?.*" (builtins.readFile /etc/os-release)) 0;
  };
}
