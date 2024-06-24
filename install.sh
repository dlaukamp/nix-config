#!/bin/sh

# Automated script to install my dotfiles

# Determine dotfiles dir
if [ $# -gt 0 ]
  then
    SCRIPT_DIR=$1
  else
    SCRIPT_DIR=~/.dotfiles
fi

# Patch different .nix-files with different username/name
sed -i "0,/dlkmp/s//$(whoami)/" $SCRIPT_DIR/flake.nix
sed -i "0,/dlkmp/s//$(whoami)/" $SCRIPT_DIR/configuration.nix
sed -i "0,/dlkmp/s//$(whoami)/" $SCRIPT_DIR/home.nix
# sed -i "s+~/.dotfiles+$SCRIPT_DIR+g" $SCRIPT_DIR/flake.nix

# Open up editor to manually edit flake.nix before install
if [ -z "$EDITOR" ]; then
    EDITOR=vim;
fi
$EDITOR $SCRIPT_DIR/flake.nix;

# Rebuild system
# sudo nixos-rebuild switch --flake $SCRIPT_DIR;

# on
if [ ! -f /tmp/foo.txt ]; then
  echo "WSL detected, remove .bashrc and .profile to prevent conflict"
  rm ~/.bashrc
  rm ~/.profile
fi

# Install and build home-manager configuration
nix run home-manager/master --extra-experimental-features 'nix-command flakes' -- switch --flake $SCRIPT_DIR --extra-experimental-features 'nix-command flakes';
