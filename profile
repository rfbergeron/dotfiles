# shellcheck shell=sh
# shellcheck disable=SC1091,SC1090

# editor
if command -v nvim >/dev/null 2>&1; then
	export EDITOR=nvim
	export VIEWER='nvim -M -R'
	export VISUAL=$EDITOR
	export SUDO_EDITOR=$EDITOR
elif command -v vim >/dev/null 2>&1; then
	export EDITOR=vim
	export VIEWER='vim -M -R'
	export VISUAL=$EDITOR
	export SUDO_EDITOR=$EDITOR
elif command -v vi >/dev/null 2>&1; then
	export EDITOR='vi'
	# i don't know if view is always shipped with vi, so just to be safe
	if ! command -v view >/dev/null 2>&1; then export VIEWER='vi -R'; fi
	export VISUAL=$EDITOR
	export SUDO_EDITOR=$EDITOR
fi

# rcfile for bourne shell/posix sh
if [ -f "$HOME"/.shrc ]; then
	export ENV="$HOME"/.shrc
fi

# less
LESS='-FRSX --mouse --use-color' # raw color escape sequences
export LESS

# make less more friendly for non-text input files and add syntax highlighting
# see lesspipe(1) and source-highlight(1)
if command -v src-hilite-lesspipe.sh >/dev/null 2>&1; then
	export LESSOPEN='| src-hilite-lesspipe.sh %s'
fi

# TODO: use cut/sed/awk to trim alias instead rather than calling unalias
if alias grep >/dev/null 2>&1; then unalias grep; fi
grep=$(if command -v grep >/dev/null 2>&1; then
	command -v grep
elif command -pv grep >/dev/null 2>&1; then
	command -pv grep
fi)
if [ -z "$grep" ]; then
	echo 'Unable to locate grep.'
	return 1
fi

# swiped from stackexchange
# changed to use command to find grep rather than assuming a particular path
pathmunge() {
	if ! echo "$PATH" | "$grep" -Eq "(^|:)$1($|:)"; then
		if [ "$2" = 'after' ]; then
			PATH="$PATH:$1"
		else
			PATH="$1:$PATH"
		fi
	fi
}

if [ -d "$HOME"/.local/bin ]; then
	pathmunge "$HOME"/.local/bin
elif [ -d "$HOME"/.bin ]; then
	pathmunge "$HOME"/.bin
fi

# default GOPATH
if [ -d "$HOME"/go ]; then
	pathmunge "$HOME"/go
fi

# default CARGO_HOME
if [ -f "$HOME"/.cargo/env ]; then
	. "$HOME"/.cargo/env
elif [ -d "$HOME"/.cargo ]; then
	pathmunge "$HOME"/.cargo/bin
fi

# source systemd environment variables; remote sessions seem to not inherit
# environment variables generated for the systemd user instance. taken from here:
# https://unix.stackexchange.com/questions/79064/how-to-export-variables-from-a-file
if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}"/environment.d/ ]; then
	set -a
	for environment in "${XDG_CONFIG_HOME:-$HOME/.config}"/environment.d/*.conf; do
		[ -f "$environment" ] && . "$environment"
	done
	set +a
fi

# no point in executing the rest of the file if we can't use xdg dirs
if [ -z "${REMOVE_CLUTTER+x}" ]; then
	unset -v grep
	unset -f pathmunge
	return
fi

# TODO: use cut/sed/awk to trim alias instead rather than calling unalias
if alias mkdir >/dev/null 2>&1; then unalias mkdir; fi
mkdir=$(if command -v mkdir >/dev/null 2>&1; then
	command -v mkdir
elif command -pv mkdir >/dev/null 2>&1; then
	command -pv mkdir
fi)
if [ -z "$mkdir" ]; then
	echo 'Unable to locate mkdir.'
	unset -v grep
	unset -f pathmunge
	return 1
fi

# xdg directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
"$mkdir" -p "$XDG_CONFIG_HOME"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
"$mkdir" -p "$XDG_CACHE_HOME"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
"$mkdir" -p "$XDG_DATA_HOME"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
"$mkdir" -p "$XDG_STATE_HOME"

# readline
if [ -f "$XDG_CONFIG_HOME"/readline/inputrc ]; then
	export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
fi

# less
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
"$mkdir" -p "$XDG_CONFIG_HOME"/less
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
"$mkdir" -p "$XDG_STATE_HOME"/less

# wget
if command -v wget >/dev/null 2>&1; then
	export WGETRC="$XDG_CONFIG_HOME"/wgetrc
fi

# openssl
if command -v openssl >/dev/null 2>&1; then
	export RANDFILE="$XDG_CACHE_HOME"/rnd
fi

# GnuPG
if command -v gpg >/dev/null 2>&1; then
	export GNUPGHOME="$XDG_DATA_HOME"/gnupg
fi

# java
if command -v java >/dev/null 2>&1; then
	export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
fi

# python
if command -v python >/dev/null 2>&1; then
	export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/startup.py
fi

# rust packages
if command -v cargo >/dev/null 2>&1; then
	export CARGO_HOME="$XDG_DATA_HOME"/cargo
	if [ -f "$CARGO_HOME"/env ]; then
		. "$CARGO_HOME"/env
	else
		pathmunge "$CARGO_HOME"/bin
	fi
fi

# rustup
if command -v rustup >/dev/null 2>&1; then
	export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
fi

# golang packages
if command -v go >/dev/null 2>&1; then
	export GOPATH="$XDG_DATA_HOME"/go
	pathmunge "$GOPATH"/bin
fi

# node repl history
if command -v node >/dev/null 2>&1; then
	export NODE_REPL_HISTORY="$XDG_STATE_HOME"/node/history
	"$mkdir" -p "$XDG_STATE_HOME"/node
fi

# npm
if command -v npm >/dev/null 2>&1; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
fi

# yarn
if command -v yarn >/dev/null 2>&1; then
	"$mkdir" -p "$XDG_CONFIG_HOME"/yarn
	# config cannot be set with an envvar so it is done as an alias
fi

# gradle
if command -v gradle >/dev/null 2>&1; then
	export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
fi

# texlive/texmf
if command -v mf >/dev/null 2>&1; then
	export TEXMFHOME="$XDG_DATA_HOME"/texmf
	export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
	export TEXMFCONFIG="$XDG_CONFIG_HOME"/texlive/texmf-config
fi

# virtualenv
if command -v virtualenv >/dev/null 2>&1; then
	export WORKON_HOME="$XDG_DATA_HOME"/virtualenvs
fi

# docker
if command -v docker >/dev/null 2>&1; then
	export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
fi

# wine
if command -v wine >/dev/null 2>&1; then
	export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
	"$mkdir" -p "$WINEPREFIX"
fi

# parallel
if command -v parallel >/dev/null 2>&1; then
	export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
fi

# elinks
if command -v elinks >/dev/null 2>&1; then
	export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
fi

# w3m
if command -v w3m >/dev/null 2>&1; then
	# TODO: some of these files belong in `$XDG_STATE_HOME` or
	# `$XDG_DATA_HOME`
	export W3M_DIR="$XDG_CONFIG_HOME"/w3m
fi

unset -v grep mkdir
unset -f pathmunge
