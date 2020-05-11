self: super: {
  myPythonEnv = super.pkgs.python3.withPackages (ps: [
    ps.mypy
    ps.pylint
    ps.yapf
  ]);
}
