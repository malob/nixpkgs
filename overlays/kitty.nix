self: super:
{
  myKitty = super.pkgs.symlinkJoin {
    name = "myKitty";
    paths = [ super.pkgs.kitty ];
    buildInputs = [ super.pkgs.makeWrapper ];
    postBuild = ''
      ${if super.stdenv.isDarwin then ''
      wrapProgram $out/Applications/kitty.app/Contents/MacOS/kitty --add-flags "--config ${./kitty.conf}"
      '' else ''
      wrapProgram $out/bin/kitty --add-flags "--config ${./kitty.conf}"
      ''}
    '';
  };
}
