self: super:
let
  batConfig = super.pkgs.writeText "bat.conf" ''
    --theme="ansi-dark"
    --style="plain"
  '';
in {
  myBat = super.pkgs.symlinkJoin rec {
    name        = "myBat";
    paths       = [ self.pkgs.unstable.bat ];
    buildInputs = [ super.pkgs.makeWrapper ];
    postBuild   = "wrapProgram $out/bin/bat --set BAT_CONFIG_PATH ${batConfig}";
  };
}
