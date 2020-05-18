self: super: {
  myIdrisEnv = with self.unstable.idrisPackages; with-packages [ contrib ];
}
