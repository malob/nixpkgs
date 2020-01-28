self: super: {

  # Update Nix user enviroment
  nixuser-rebuild-nixos = super.writeShellScriptBin "nixuser-rebuild" "nix-env -riA nixos.myNixosEnv";

  myNixosEnv = self.buildEnv {
    name  = "NixosEnv";
    paths = with self.pkgs; [
      myCommonEnv

      slack
      vscode

      # My custom nix related shell scripts
      nixuser-rebuild-nixos
    ];
  };
}
