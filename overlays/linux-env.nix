self: super: {

  # Update Nix user enviroment
  nixuser-rebuild-linux = super.writeShellScriptBin "nixuser-rebuild" "nix-env -riA nixpkgs.myLinuxEnv";

  myLinuxEnv = self.buildEnv {
    name  = "LinuxEnv";
    paths = with self.pkgs; [
      myCommonEnv

      unstable.abduco

      # My custom nix related shell scripts
      nixuser-rebuild-linux
    ];
  };
}
