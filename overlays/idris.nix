self: super: {
  myIdris = with self.idrisPackages; with-packages [ contrib ];
}
