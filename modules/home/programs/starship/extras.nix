{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrsRecursiveCond
    mkDefault
    mkMerge
    ;

  cfg = config.programs.starship.extras;

  presetNames = [
    "bracketed-segments"
    "catppuccin-powerline"
    "gruvbox-rainbow"
    "jetpack"
    "nerd-font-symbols"
    "no-empty-icons"
    "no-nerd-font"
    "no-runtime-versions"
    "pastel-powerline"
    "plain-text-symbols"
    "pure-preset"
    "tokyo-night"
  ];

  # Convert preset name to valid Nix identifier (replace hyphens with underscores)
  toIdentifier = name: builtins.replaceStrings [ "-" ] [ "_" ] name;

  # Generate TOML for a preset and parse it
  getPresetSettings =
    name:
    let
      tomlFile = pkgs.runCommand "starship-preset-${name}.toml" { } ''
        ${pkgs.starship}/bin/starship preset ${name} > $out
      '';
      parsed = builtins.fromTOML (builtins.readFile tomlFile);
    in
    # Remove $schema key if present
    builtins.removeAttrs parsed [ "$schema" ];

  # Recursively apply mkDefault to all leaf values
  applyMkDefault =
    attrs:
    mapAttrsRecursiveCond (v: builtins.isAttrs v && !(v ? _type)) # Don't recurse into mkDefault values
      (_path: value: mkDefault value)
      attrs;

  # Generate preset options
  presetOptions = builtins.listToAttrs (
    map (name: {
      name = toIdentifier name;
      value = mkEnableOption "the ${name} starship preset";
    }) presetNames
  );

  # Generate config for each enabled preset
  presetConfigs = map (
    name:
    let
      id = toIdentifier name;
    in
    mkIf cfg.presets.${id} {
      programs.starship.settings = applyMkDefault (getPresetSettings name);
    }
  ) presetNames;

in
{
  options.programs.starship.extras.presets = presetOptions;

  config = mkIf config.programs.starship.enable (mkMerge presetConfigs);
}
