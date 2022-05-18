{ config, lib, ... }:

{
  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
    templates = {
      scm-init = "git";
      params = {
        author-name = config.programs.git.userName;
        author-email = config.programs.git.userEmail;
        github-username = "malob";
      };
    };
    nix.enable = true;
  };

  # Stop `parallel` from displaying citation warning
  home.file.".parallel/will-cite".text = "";
}
