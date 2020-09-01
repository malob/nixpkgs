self: super: {
  myGems = super.pkgs.callPackage ../pkgs/ruby-gems {};
  myNodePackages =  super.pkgs.callPackage ../pkgs/node-packages {};
  myPythonPackages = import ../pkgs/python-packages/requirements.nix {pkgs = self;};

  prefmanager = import (import ../nix/sources.nix).prefmanager {};

  myTickgit = super.pkgs.buildGoModule rec {
    pname = "tickgit";
    version = "HEAD";

    src = super.pkgs.fetchFromGitHub {
      owner = "augmentable-dev";
      repo = "tickgit";
      rev = "9d0b151";
      sha256 = "1y6416d52qd9cfa4wh4ssarcbl04x6hf157jvas57l9xqkm1b0kq";
    };

    modSha256 = "1ayhg0p3qlgpvahb32iq5xlaydn1gcwr90szyrbjgr7f7cazwqx2";

    subPackages = [ "cmd/tickgit" ];

    meta = with super.lib; {
      description = "Manage your repository's TODOs, tickets and checklists as config in your codebase.";
      homepage = https://github.com/augmentable-dev/tickgit;
      license = licenses.mit;
      maintainers = with maintainers; [ malob ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };
}
