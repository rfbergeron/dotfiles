#!/bin/sh

# cd into the bundle and use relative paths
cd "$(dirname "$0")" || {
	echo 'Unable to cd into bundle directory; exiting.'
	exit 1
}
[ -n "$HOME" ] || {
	echo "\$HOME is unset; exiting."
	exit 1
}
[ -r "$HOME" ] || {
	echo "Unable to read files in \$HOME; exiting."
	exit 1
}

cp "$HOME"/.shrc ./shrc
cp "$HOME"/.profile ./profile

if [ -f "$HOME"/.bashrc ]; then
	cp "$HOME"/.bashrc ./bashrc
	cp "$HOME"/.bash_profile ./bash_profile
	#cp "$HOME/.bash_logout" ./bash_logout
fi

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

if [ -f "$config_dir"/readline/inputrc ]; then
	cp "$config_dir"/readline/inputrc ./
elif [ -f "$HOME"/.inputrc ]; then
	cp "$HOME"/.inputrc ./inputrc
fi

if [ -f "$config_dir"/tmux/tmux.conf ]; then
	cp "$config_dir"/tmux/tmux.conf ./
elif [ -f "$HOME"/.tmux.conf ]; then
	cp "$HOME"/.tmux.conf ./tmux.conf
fi

if [ -f "$config_dir"/npm/npmrc ]; then
	cp "$config_dir"/npm/npmrc ./
fi

if [ -f "$config_dir"/python/startup.py ]; then
	cp "$config_dir"/python/startup.py ./
fi

if [ -f "$config_dir"/maven/settings.xml ]; then
	cp "$config_dir"/maven/settings.xml ./maven/settings.xml
fi

if [ -d "$config_dir"/nvim ]; then
	cp "$config_dir"/nvim/init.lua ./nvim/
fi
