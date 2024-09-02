{ config, lib, ... }:

let
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    stateHome
    ;
in

{
  # Enable XDG Base Directory support
  xdg.enable = true;
  home.preferXdgDirectories = true;

  # Bundler (Ruby)
  # https://bundler.io/v2.5/man/bundle-config.1.html
  home.sessionVariables.BUNDLE_USER_CONFIG = "${configHome}/bundle/config";
  home.sessionVariables.BUNDLE_USER_CACHE = "${cacheHome}/bundle";
  home.sessionVariables.BUNDLE_USER_PLUGIN = "${dataHome}/bundle/plugin";

  # Cargo
  # https://doc.rust-lang.org/cargo/reference/environment-variables.html
  home.sessionVariables.CARGO_HOME = "${dataHome}/cargo";

  # Less
  home.sessionVariables.LESSHISTFILE = "${stateHome}/lesshst";

  # Node.js configuration
  # https://nodejs.org/api/repl.html#environment-variable-options
  home.sessionVariables.NODE_REPL_HISTORY = "${stateHome}/node_repl_history";

  # NPM
  # https://docs.npmjs.com/cli/v6/configuring-npm/npmrc
  home.sessionVariables.NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
  xdg.configFile."npm/npmrc".text = "cache = ${cacheHome}/npm";

  # Parallel: Stop displaying citation warning
  # https://www.gnu.org/software/parallel/parallel.html#environment-variables
  home.sessionVariables.PARALLEL_HOME = "${configHome}/parallel";
  xdg.configFile."parallel/will-cite".text = "";

  # Stack
  # https://docs.haskellstack.org/en/stable/stack_root/
  home.sessionVariables.STACK_XDG = "1";

  # Non-project-specific Stack config
  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  xdg.configFile."stack/config.yaml".text = lib.generators.toYAML { } {
    templates = {
      scm-init = "git";
      params = {
        author-name = config.programs.git.userName;
        author-email = config.programs.git.userEmail;
        github-username = "malob";
      };
    };
    nix.enable = true;
    recommend-stack-upgrade = false;
  };

  # Wget
  # https://www.gnu.org/software/wget/manual/wget.html#Wgetrc-Location-1
  home.sessionVariables.WGETRC = "${configHome}/wget/wgetrc";
  xdg.configFile."wget/wgetrc".text = ''
    hsts-file = ${dataHome}/wget/hsts
  '';
}
