[![Cachix](https://img.shields.io/badge/cachix-hie--nix-blue.svg)](https://hie-nix.cachix.org)
[![Build Status](https://travis-ci.org/domenkozar/hie-nix.svg?branch=master)](https://travis-ci.org/domenkozar/hie-nix)

# Purpose

The purpose of this repository is to provide [HIE](https://github.com/haskell/haskell-ide-engine)
for each major GHC version installable via Nix.

Hie built with specific GHC needs to match the major version of GHC used on development project.


# Install

For linux you can use binaries provided by Cachix. See [instructions](https://hie-nix.cachix.org) how to configure cachix. Otherwise (on macOS) be prepared to compile for a while.

To install a wrapper that will be able to pick between `hie-8.2` and `hie-8.4`:

    $ nix-env -iA hies -f https://github.com/domenkozar/hie-nix/tarball/master
    $ hie-8.2 --help
    $ hie-8.4 --help

Or for just a specific GHC and get `hie`:

    $ nix-env -iA hie84 -f https://github.com/domenkozar/hie-nix/tarball/master
    $ hie --help
 

# Updating HIE

    # edit commit in update.sh
    $ ./update.sh

# FAQ

## How do I make editor integrate the right hie version?

Install `hies` which will include all supported GHC versions and the wrapper supported
by most editors.


## How do I integrate my editor?

See https://github.com/haskell/haskell-ide-engine#editor-integration 

## Does hie-nix work with Stack?

Yes, but make sure you have Nix enabled in either `stack.yaml` in your project or globally:

    $ cat ~/.stack/config.yaml
    nix: 
      enable: true

