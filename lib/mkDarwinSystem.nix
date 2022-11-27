inputs:

{ username
, fullName
, email
, nixConfigDirectory
, system ? "aarch64-darwin"
, modules ? [ ]
, extraModules ? [ ]
, homeModules ? [ ]
, extraHomeModules ? [ ]
, homeStateVersion ? "22.11"
}:

inputs.darwin.lib.darwinSystem {
  inherit system;
  modules = modules ++ extraModules ++ [
    inputs.home-manager.darwinModules.home-manager
    ({ config, ... }: {
      users.primaryUser = { inherit username fullName email nixConfigDirectory; };

      # Hack to support legacy worklows that use `<nixpkgs>` etc.
      nix.nixPath.nixpkgs = "${inputs.nixpkgs-unstable}";

      # `home-manager` config
      users.users.${username}.home = "/Users/${username}";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        imports = homeModules ++ extraHomeModules;
        home.stateVersion = homeStateVersion;
        home.user-info = config.users.primaryUser;
      };
    })
  ];
}
