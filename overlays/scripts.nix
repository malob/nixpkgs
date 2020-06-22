self: super:
let
  #################################
  # Cross platform helper scripts #
  #################################

  # Collect garbage, optimize store, repair paths
  nix-cleanup-store = super.writeShellScriptBin "nix-cleanup-store" ''
    nix-collect-garbage -d
    nix optimise-store 2>&1 | sed -E 's/.*'\'''(\/nix\/store\/[^\/]*).*'\'''/\1/g' | uniq | sudo -E ${super.pkgs.parallel}/bin/parallel 'nix-store --repair-path {}'
  '';

  # Update custom packages
  nix-update-mypkgs = super.writeShellScriptBin "nix-update-mypkgs" ''
    pushd ~/.config/nixpkgs/pkgs/node-packages
    printf "\n*************************************\n"
    printf "\nUpdating Node package nix expressions\n"
    printf "\n*************************************\n"
    ${self.pkgs.unstable.nodePackages.node2nix}/bin/node2nix --nodejs-10 -i node-packages.json
    popd
    pushd ~/.config/nixpkgs/pkgs/ruby-gems/
    printf "\n**********************************\n"
    printf "\nUpdating Ruby Gems nix expressions\n"
    printf "\n**********************************\n"
    ${super.pkgs.bundix}/bin/bundix --magic
    popd
    pushd ~/.config/nixpkgs/pkgs/python-packages
    printf "\n***************************************\n"
    printf "\nUpdating Python package nix expressions\n"
    printf "\n***************************************\n"
    ${super.pkgs.unstable.pypi2nix}/bin/pypi2nix --python-version python37 --requirements requirements.txt
    popd
  '';


  ########################
  # macOS helper scripts #
  ########################

  # Update Nix on macOS (see https://nixos.org/nix/manual/#ch-upgrading-nix)
  nix-update-self = super.writeShellScriptBin "nix-update-self" ''
    sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'
  '';

  # Symlink macOS apps installed via Nix into ~/Applications
  nix-symlink-apps-macos = super.writeShellScriptBin "nix-symlink-apps-macos" ''
    for app in $(find ~/Applications -name '*.app')
    do
      if test -L $app && [[ $(readlink -f $app) == /nix/store/* ]]; then
        rm $app
      fi
    done

    for app in $(find ~/.nix-profile/Applications/ -name '*.app' -exec readlink -f '{}' \;)
    do
      ln -s $app ~/Applications/$(basename $app)
    done
  '';

  # Update Homebrew pagkages/apps
  brew-bundle-update = super.writeShellScriptBin "brew-bundle-update" ''
    brew update
    brew bundle --file=~/.config/nixpkgs/Brewfile
  '';

  # Remove Homebrew pakages/apps not in Brewfile
  brew-bundle-cleanup = super.writeShellScriptBin "brew-bundle-cleanup" ''
    brew bundle cleanup --zap --force --file=~/.config/nixpkgs/Brewfile
  '';

in {
  myenv-script = super.writeShellScriptBin "myenv" ''
    ${if super.stdenv.isDarwin then ''
    # Brew
    if [ $1 = 'update' ] || ([ $1 = 'brew' ] && [ $2 = ""]); then
      ${brew-bundle-update}/bin/brew-bundle-update
      if [ $1 = 'brew' ]; then exit 0; fi
    elif [ $1 = 'clean' ] || ([ $1 = 'brew' ] && [ $2 = 'clean' ]); then
      ${brew-bundle-cleanup}/bin/brew-bundle-cleanup
      if [ $1 = 'brew' ]; then exit 0; fi
    fi

    '' else ""}
    # Nix
    if [ $1 = 'update' ] || ([ $1 = 'nix' ] && [ $2 = 'update' ]); then
      pushd ~/.config/nixpkgs
      ${self.unstable.pkgs.niv}/bin/niv update $3
      popd
    fi

    if [ $1 = 'update' ] || ([ $1 = 'nix' ] && [ $2 = 'update-mypkgs' ]); then
      ${nix-update-mypkgs}/bin/nix-update-mypkgs
    fi

    if [ $1 = 'update' ] || ([ $1 = 'nix' ] && ([ $2 = 'update' ] || [ $2 = 'update-mypkgs' ] || [ $2 = 'rebuild' ])); then
      nix-env -riA nixpkgs.myEnv
      ${if super.stdenv.isDarwin then ''
      ${nix-symlink-apps-macos}/bin/nix-symlink-apps-macos
      '' else ""}
      if [ $1 = 'nix' ]; then exit 0; fi
    elif [ $1 = 'clean' ] || ([ $1 = 'nix' ] && [ $2 = 'clean' ]); then
      ${nix-cleanup-store}/bin/nix-cleanup-store
      if [ $1 = 'nix' ]; then exit 0; fi
    ${if super.stdenv.isDarwin then ''
    elif [ $1 = 'nix' ] && [ $2 = 'update-self' ]; then
      ${nix-update-self}/bin/nix-update-self
      exit 0
    '' else ""}
    fi

    # Other
    if [ $1 = 'update' ]; then
      tldr --update
      fish -C fish_update_completions
    else
      echo "Unknown command"
    fi
  '';

  # Enable `sudo` with TouchID
  enable-touchid-sudo = super.writeShellScriptBin "enable-touchid-sudo" ''
    if ! grep pam_tid.so /etc/pam.d/sudo > /dev/null; then
      sed -i.old '2i\
      auth       sufficient     pam_tid.so
      ' /etc/pam.d/sudo
    fi
  '';
}
