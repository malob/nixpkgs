self: super: {
  # Command to update Nix user enviroment that picks right environment based on OS
  nixuser-rebuild = super.writeShellScriptBin "nixuser-rebuild" ''
    if [ "$1" == "--update" ]; then
      nixuser-update-sources
    fi

    if [ $(uname) == "Darwin" ]; then
      nix-env -riA nixpkgs.myMacosEnv
      nixuser-simlink-apps
    elif test -f /etc/nixos/configuration.nix; then
      nix-env -riA nixos.myNixosEnv
    else
      nix-env -riA nixpkgs.myLinuxEnv
    fi
  '';

  # Command to update channels and custom package sources
  nixuser-update-sources = super.writeShellScriptBin "nixuser-update-sources" ''
    nix-channel --update
    pushd ~/.config/nixpkgs/pkgs/node-packages
    echo -e "\nUpdating Node package nix expressions ...\n"
    node2nix --nodejs-10 -i node-packages.json
    popd
    pushd ~/.config/nixpkgs/pkgs/ruby-gems/
    echo -e "\nUpdating Ruby Gems nix expressions ...\n"
    bundix --magic
    popd
    pushd ~/.config/nixpkgs/pkgs/python-packages
    echo "\nUpdating Python package nix expressions ...\n"
    pypi2nix --python-version 3.6 --requirements requirements.txt
    popd
  '';

  # Command to simlink macOS apps installed via Nix into ~/Applications
  nixuser-simlink-apps = super.writeShellScriptBin "nixuser-simlink-apps" ''
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

  # Command to update Nix on macOs
  nix-update-darwin = super.writeShellScriptBin "nix-update" ''
     sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'
  '';
}
