self: super: {
  myGems = super.pkgs.callPackage ../pkgs/ruby-gems {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};
  myPythonPackages = import ../pkgs/python-packages/requirements.nix {pkgs = self;};
}
