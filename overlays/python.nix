final: prev:

let
  inherit (prev) python3 fetchFromGitHub;
  inherit (prev.python3.pkgs) buildPythonApplication;
in

{
  python3 = python3.override {
    packageOverrides = self: super: {

      shell-functools = buildPythonApplication {
        pname = "shell-functools";
        version = "HEAD";

        src = fetchFromGitHub {
          owner = "sharkdp";
          repo = "shell-functools";
          rev = "228ec11";
          sha256 = "8WpDTetoTaCPRDWe5vHxSoz+oVSNuxIahbDsPhecpv0=";
        };

        meta = with prev.lib; {
          homepage = "https://github.com/sharkdp/shell-functools";
          description = "A collection of functional programming tools for the shell.";
          license = licenses.mit;
        };

      };
    };
  };
}
