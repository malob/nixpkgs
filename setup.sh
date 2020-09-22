#! /bin/bash

if grep 'NAME="Ubuntu"' /etc/os-release > /dev/null; then
  # Install Nix
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
  source ~/.nix-profile/etc/profile.d/nix.sh

  # Clone personal Nix configuration
  mkdir ~/.config
  git clone git@github.com:malob/nixpkgs.git ~/.config/nixpkgs

  # Create required simlinks to use channels managed by Niv
  rm -rf ~/.nix-defexpr ~/.nix-channels
  ln -s ~/.config/nixpkgs/nix/nix-defexpr ~/.nix-defexpr

  # Install Home Manager and personal Nix configuration
  nix-shell '<home-manager>' -A install

  # Other misc stuff
  tldr --update

  # Jump into Fish shell 
  exec fish
fi
