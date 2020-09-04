# Enviroment for various programing languages and related tools
self: super: {
  myenvs = {

    agda = self.pkgs.agda.withPackages (p: [ p.standard-library ]);

    haskell = self.pkgs.haskellPackages.ghcWithPackages (hPkgs: with hPkgs; [
      haskell-language-server
      hoogle
      hpack
      implicit-hie
      stack
    ]);

    idris = with self.idrisPackages; with-packages [ contrib ];

    python = self.pkgs.stable.python3.withPackages (ps: [
      ps.mypy
      ps.pylint
      ps.yapf
    ]);
  };
}
