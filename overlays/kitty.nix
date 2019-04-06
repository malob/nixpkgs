self: super:
{
  myKitty = super.pkgs.symlinkJoin {
    name = "myKitty";
    paths = [ super.pkgs.kitty ];
    buildInputs = [ super.pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/kitty --add-flags "--config ${./kitty.conf}"
    '';
  };
}
