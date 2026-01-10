{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null; # Installed via Homebrew

    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = {
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
    };

    themes = {
      light = config.colors.malo-ok-solar-light.pkgThemes.ghostty;
      dark = config.colors.malo-ok-solar-dark.pkgThemes.ghostty;
    };
  };
}
