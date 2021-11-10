final: prev:

let
  buildVimPluginFromFlakeInput = inputs: name:
    prev.vimUtils.buildVimPluginFrom2Nix {
      pname = name;
      version = inputs.${name}.lastModifiedDate;
      src = inputs.${name};
    };

  buildNeovimLuaPackagePlugin = { pname, src, version ? "HEAD" }:
    final.vimUtils.buildVimPluginFrom2Nix {
      inherit pname version;
      src = prev.linkFarm pname [ { name = "lua"; path = src; } ];
    };
in

{
  vimUtils = prev.vimUtils // {
    inherit buildVimPluginFromFlakeInput buildNeovimLuaPackagePlugin;

    # Vim Plugin helpers
    buildVimPluginsFromFlakeInputs = inputs: names:
      prev.lib.genAttrs names (buildVimPluginFromFlakeInput inputs);

    buildNeovimLuaPackagePluginFromFlakeInput = inputs: name:
      buildNeovimLuaPackagePlugin {
        pname = name + "-nvim";
        version = inputs.${name}.lastModifiedDate;
        src = inputs.${name};
      };
  };
}
