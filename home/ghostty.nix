{ config, lib, ... }:

let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;

  mkThemeConfig = toKeyValue {
    mkKeyValue = mkKeyValueDefault { } " = ";
    listsAsDuplicateKeys = true;
  };
in

{
  xdg.configFile."ghostty/themes/light".text =
    mkThemeConfig config.colors.malo-ok-solar-light.pkgThemes.ghostty;

  xdg.configFile."ghostty/themes/dark".text =
    mkThemeConfig config.colors.malo-ok-solar-dark.pkgThemes.ghostty;

  xdg.configFile."ghostty/config".text = toKeyValue { mkKeyValue = mkKeyValueDefault { } " = "; } {
    font-family = "PragmataPro Liga";
    font-size = 14;
    font-thicken = true;

    adjust-cell-height = "40%";
    adjust-cursor-height = "40%";
    adjust-cursor-thickness = "100%";
    adjust-box-thickness = "100%";
    adjust-underline-thickness = "400%";

    theme = "light:light,dark:dark";
    window-theme = "system";
    window-colorspace = "display-p3";
    # background-opacity = 0.9;
    # background-blur-radius = 20;
    window-padding-x = 10;
    window-padding-y = 10;

    auto-update = "download";
  } + ''
    # Fix sending shift+enter for Claude Code
    keybind = shift+enter=text:\x1b\r
  '';
}
