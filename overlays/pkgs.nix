# Packages for which I've created my own Nix derivations
final: prev: {
  nodePackages = prev.nodePackages // prev.callPackage ../pkgs/node-packages {};

  tickgit = prev.buildGoModule rec {
    pname = "tickgit";
    version = "HEAD";

    src = prev.fetchFromGitHub {
      owner = "augmentable-dev";
      repo = "tickgit";
      rev = "9d0b151";
      sha256 = "1y6416d52qd9cfa4wh4ssarcbl04x6hf157jvas57l9xqkm1b0kq";
    };

    vendorSha256 = "VPDj9wjUZQRXjjRcGhpDVz4e4MCIBUgTvZNzdCBDXdg=";

    subPackages = [ "cmd/tickgit" ];

    meta = with prev.lib; {
      description = "Manage your repository's TODOs, tickets and checklists as config in your codebase.";
      homepage = https://github.com/augmentable-dev/tickgit;
      license = licenses.mit;
      maintainers = with maintainers; [ malob ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };
}
