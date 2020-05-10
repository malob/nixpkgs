self: super: {
  myPythonEnv = with self.pkgs; super.buildEnv {
    name  = "PythonEnv";
    paths = [
      python3
      python3Packages.pylint
    ];
  };
}
