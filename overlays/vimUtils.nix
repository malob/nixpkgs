final: prev:

let
  buildVimPluginFromFlakeInput = inputs: name:
    prev.vimUtils.buildVimPluginFrom2Nix {
      pname = name;
      version = inputs.${name}.lastModifiedDate;
      src = inputs.${name};
    };
in

{
  vimUtils = prev.vimUtils // {
    inherit buildVimPluginFromFlakeInput;

    # Vim Plugin helpers
    buildVimPluginsFromFlakeInputs = inputs: names:
      prev.lib.genAttrs names (buildVimPluginFromFlakeInput inputs);
  };
}
