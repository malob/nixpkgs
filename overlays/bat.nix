self: super: {
  myBat = super.pkgs.symlinkJoin rec {
    name        = "myBat";
    paths       = [ self.pkgs.unstable.bat ];
    buildInputs = [ super.pkgs.makeWrapper ];
    configPath  = "$out/.config/bat";
    batConfig   = ''
      --theme="ansi-dark"
      --style="plain"
    '';
    postBuild = ''
      mkdir -p ${configPath}
      echo '${batConfig}' > ${configPath}/bat.conf
      wrapProgram $out/bin/bat --set BAT_CONFIG_PATH ${configPath}/bat.conf
    '';
  };
}
