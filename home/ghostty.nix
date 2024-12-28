{ config, lib, ... }:

let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;

  mkThemeConfig = toKeyValue {
    mkKeyValue = mkKeyValueDefault { } " = ";
    listsAsDuplicateKeys = true;
  };
in

{
  xdg.configFile."ghostty/themes/Solarized Light".text =
    mkThemeConfig config.colors.solarized-light.pkgThemes.ghostty;

  xdg.configFile."ghostty/themes/Solarized Dark".text =
    mkThemeConfig config.colors.solarized-dark.pkgThemes.ghostty;

  xdg.configFile."ghostty/config".text = toKeyValue { mkKeyValue = mkKeyValueDefault { } " = "; } {
    font-family = "PragmataPro Liga";
    font-size = 14;
    font-thicken = true;

    adjust-cell-height = "40%";
    adjust-cursor-height = "40%";
    adjust-cursor-thickness = "100%";
    adjust-box-thickness = "100%";
    adjust-underline-thickness = "400%";

    theme = "light:Solarized Light,dark:Solarized Dark";
    window-theme = "system";
    window-colorspace = "display-p3";
    background-opacity = 0.9;
    background-blur-radius = 20;
    window-padding-x = 10;
    window-padding-y = 10;

    auto-update = "download";
  };
}
