self: super: {
  myAgdaEnv = super.pkgs.unstable.agda.withPackages (p: [ p.standard-library ]);
}
