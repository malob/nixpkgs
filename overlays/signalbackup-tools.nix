final: prev:

let
  inherit (prev.stdenv) mkDerivation;
  inherit (prev) fetchFromGitHub openssl sqlite;
in
{
  signalbackup-tools = mkDerivation rec {
    pname = "signalbackup-tools";
    version = "20211109";

    src = fetchFromGitHub {
      owner = "bepaald";
      repo = "signalbackup-tools";
      rev = version;
      sha256 = "UgPEmrp2L4zKTcdgoJCI0DFIUVcexxvI3RxDU7X6XIw=";
    };

    buildInputs = [ openssl sqlite ];
    buildPhase = ''
      $CXX -std=c++2a */*.cc *.cc -lcrypto -lsqlite3 -o signalbackup-tools
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp signalbackup-tools $out/bin/
    '';
  };
}
