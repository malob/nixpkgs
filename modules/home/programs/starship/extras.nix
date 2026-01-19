{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    mapAttrsRecursiveCond
    mkDefault
    types
    ;

  cfg = config.programs.starship.extras;

  # Convert Nix identifier back to preset name (underscores to hyphens)
  fromIdentifier = name: builtins.replaceStrings [ "_" ] [ "-" ] name;

  # Recursively apply mkDefault to all leaf values
  applyMkDefault =
    attrs:
    mapAttrsRecursiveCond (v: builtins.isAttrs v && !(v ? _type)) # Don't recurse into mkDefault values
      (_path: value: mkDefault value)
      attrs;

in
{
  options.programs.starship.extras.presets = mkOption {
    type = types.attrsOf types.bool;
    default = { };
    example = {
      nerd_font_symbols = true;
    };
    description = ''
      Starship presets to enable. Use underscores instead of hyphens in preset names.
      Available presets are discovered automatically from the starship package.
      See https://starship.rs/presets/ for available presets.
    '';
  };

  config = mkIf config.programs.starship.enable (
    let
      presetsDir = "${pkgs.starship}/share/starship/presets";

      # Read and parse a preset TOML file
      getPresetSettings =
        name:
        let
          parsed = builtins.fromTOML (builtins.readFile "${presetsDir}/${name}.toml");
        in
        builtins.removeAttrs parsed [ "$schema" ];

      # Get enabled presets and apply their settings
      enabledPresets = lib.filterAttrs (_: enabled: enabled) cfg.presets;
      presetSettings = lib.mapAttrsToList (
        id: _:
        let
          name = fromIdentifier id;
        in
        applyMkDefault (getPresetSettings name)
      ) enabledPresets;
    in
    {
      programs.starship.settings = lib.mkMerge presetSettings;
    }
  );
}
