# Packages for which I've created my own Nix derivations
self: super:
let
  sources = import ../nix/sources.nix;
in
{
  mypkgs = {
    nodePackages = super.pkgs.callPackage ../pkgs/node-packages {};

    prefmanager = (import sources.prefmanager {}).prefmanager.components.exes.prefmanager;

    comma = import sources.comma {};

    tickgit = super.pkgs.buildGoModule rec {
      pname = "tickgit";
      version = "HEAD";

      src = super.pkgs.fetchFromGitHub {
        owner = "augmentable-dev";
        repo = "tickgit";
        rev = "9d0b151";
        sha256 = "1y6416d52qd9cfa4wh4ssarcbl04x6hf157jvas57l9xqkm1b0kq";
      };

      vendorSha256 = "VPDj9wjUZQRXjjRcGhpDVz4e4MCIBUgTvZNzdCBDXdg=";

      subPackages = [ "cmd/tickgit" ];

      meta = with super.lib; {
        description = "Manage your repository's TODOs, tickets and checklists as config in your codebase.";
        homepage = https://github.com/augmentable-dev/tickgit;
        license = licenses.mit;
        maintainers = with maintainers; [ malob ];
        platforms = platforms.linux ++ platforms.darwin;
      };
    };

    neovim-nightly = with self.pkgs; neovim-unwrapped.overrideAttrs (
      attrs: {
        pname = "neovim-nightly";
        version = "master";
        nativeBuildInputs = attrs.nativeBuildInputs
        ++ [ tree-sitter ];
        src = sources.neovim;
      }
    );
  };
}
