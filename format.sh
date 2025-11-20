#!/bin/sh
shfmt --write --posix shrc profile install.sh update-repo.sh \
    setup-gnome-keybindings.sh
shfmt --write --language-dialect bash bashrc bash_profile
black --quiet startup.py
stylua nvim/init.lua
