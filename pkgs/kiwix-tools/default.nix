{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "kiwix-tools-${version}";
  version = "1.1.0";
  src = fetchurl {
    url = "http://download.kiwix.org/release/kiwix-tools/kiwix-tools_linux-x86_64-${version}.tar.gz";
    sha256 = "0i8a3093z3ldqgpbl5nwz1jypridi0ayrr5s0fa58ian615hfwqm";
  };
  installPhase = ''
      mkdir -p $out/bin
      cp kiwix-* $out/bin
  '';
}
