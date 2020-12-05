# Inspired by: https://github.com/lccambiaghi/nixpkgs/blob/main/modules/homebrew.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.homebrew;

  writeBrewfileEntries = type: concatMapStrings (name: "${type} \"${name}\"\n");

  writeMasEntries = entries: concatStringsSep "\n" (mapAttrsToList (name: id: "mas \"${name}\", id: ${toString id}") entries);

  brewfile = pkgs.writeText "Brewfile" ''
    ${"# Taps\n" + (writeBrewfileEntries "tap" cfg.taps) + "\n"}
    ${"# Formulas\n" + (writeBrewfileEntries "brew" cfg.brews) + "\n"}
    ${"# Casks\n" + (writeBrewfileEntries "cask" cfg.casks) + "\n"}
    ${"# Mac App Store apps\n" + (writeMasEntries cfg.masApps) + "\n"}
    ${"# Docker containers\n" + (writeBrewfileEntries "whalebrew" cfg.whalebrews) + "\n"}
  '';

  nix-brew = pkgs.writeShellScriptBin "nix-brew" ''
    PATH=/usr/local/bin:$PATH
    brew update
    brew bundle --no-lock --file="${brewfile}"
  '';

  nix-brew-cleanup = pkgs.writeShellScriptBin "nix-brew-cleanup" ''
    PATH=/usr/local/bin:$PATH
    brew update
    brew bundle --cleanup --no-lock --file="${brewfile}"
  '';

in

{
  options.programs.homebrew = {
    enable = mkEnableOption ''
      Enable managing packages and applications using `brew bundle` through nix-darwin.
    '';

    cleanup = mkEnableOption ''
      Perform a cleanup when running command.
    '';

    taps = mkOption {
      description = "Homebrew formula repositories to tap";
      type = with types; listOf str;
      default = [];
      example = [ homebrew/cask-fonts ];
    };

    brews = mkOption {
      description = "Homebrew formulea to install";
      type = with types; listOf str;
      default = [];
      example = [ mas ];
    };

    casks = mkOption {
      description = "Homebrew casks to install";
      type = with types; listOf str;
      default = [];
      example = [ hammerspoon virtualbox ];
    };

    masApps = mkOption {
      description = "Applications to install from Mac App Store using `mas`";
      type = with types; attrsOf int;
      default = {};
      example = {
        "1Password" = 1107421413;
        Xcode = 497799835;
      };
    };

    whalebrews = mkOption {
      description = "Docker images to install";
      type = with types; listOf str;
      default = [];
      example = [ whalebrew/wget ];
    };
  };

  config = mkIf cfg.enable {
    programs.homebrew.brews = optional (cfg.masApps != {}) "mas";

    system.activationScripts.extraUserActivation.text = ''
      ${if cfg.cleanup then
        "${nix-brew-cleanup}/bin/nix-brew-cleanup"
      else
        "${nix-brew}/bin/nix-brew"
      }
    '';
  };

}
