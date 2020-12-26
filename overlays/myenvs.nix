# Enviroment for various programing languages and related tools
self: super: {
  myenvs = {

    agda = self.pkgs.stable.agda.withPackages (p: [ p.standard-library ]);

    haskell = super.buildEnv {
      name = "myHaskellEnv";
      paths = with self.pkgs; [
        haskell-language-server
        haskellPackages.hoogle
        haskellPackages.hpack
        haskellPackages.implicit-hie
        stable.stack
      ];
    };

    idris = self.pkgs.idris2; # with self.idrisPackages; with-packages [ contrib ];

    python = self.pkgs.python3.withPackages (
      ps: [
        ps.mypy
        ps.pylint
        ps.yapf
      ]
    );
  };
}
