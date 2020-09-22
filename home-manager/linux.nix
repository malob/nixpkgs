{ ... }:

{
  # lorri, improve `nix-shell` experience in combination with `direnv`
  # https://github.com/target/lorri
  # Setup of lorri daemon is handle by nix-darwin on macOS and system config for NixOS
  services.lorri.enable = true;
}
