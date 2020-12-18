{ config, pkgs, lib, ... }:

{
  imports = [ ./configuration.nix ];

  environment.darwinConfig = lib.mkForce "$HOME/.config/nixpkgs/darwin/ci.nix";

  users.users = lib.mkForce {
    runner.home = "/Users/runner";
  };

  home-manager.users = lib.mkForce {
    runner = import ../home-manager/configuration.nix;
  };

  homebrew.cleanup = lib.mkForce "none";
  homebrew.masApps = lib.mkForce {};
}
