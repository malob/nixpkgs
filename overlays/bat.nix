self: super:
let
  batConfig = ''
    --theme="ansi-dark"
    --style="plain"
  '';
in {
  myBat = super.pkgs.symlinkJoin {
    name = "myBat";
    paths = [ self.pkgs.unstable.bat ];
    buildInputs = [ super.pkgs.makeWrapper ];
    postBuild = ''
      mkdir -p "$out/.config/bat"
      echo '${batConfig}' > "$out/.config/bat/bat.conf"
      wrapProgram $out/bin/bat --set BAT_CONFIG_PATH "$out/.config/bat/bat.conf"
    '';
  };
}
