#!/bin/sh
shellcheck profile shrc bash_profile bashrc install.sh update-repo.sh \
    setup-gnome-keybindings.sh
pycodestyle startup.py
stylua --check nvim/init.lua
