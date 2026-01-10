{ pkgs, ... }:

let
  inherit (builtins) attrValues;
in

{
  # Networking
  networking.dns = [
    "1.1.1.1" # Cloudflare
    "8.8.8.8" # Google
  ];

  # Fonts
  fonts.packages = attrValues {
    inherit (pkgs)
      recursive
      ;

    inherit (pkgs.nerd-fonts)
      jetbrains-mono
      ;
  };

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  # Swap Caps Lock and Escape
  system.keyboard.userKeyMapping = [
    {
      HIDKeyboardModifierMappingSrc = 30064771129;
      HIDKeyboardModifierMappingDst = 30064771113;
    }
    {
      HIDKeyboardModifierMappingSrc = 30064771113;
      HIDKeyboardModifierMappingDst = 30064771129;
    }
  ];

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Firewall
  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

}
