# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091

if [[ -f "$HOME/.profile" ]]; then source "$HOME/.profile"; fi

# put histfile in state
if [[ -n "$XDG_STATE_HOME" ]]; then
	mkdir -p "$XDG_STATE_HOME/bash"
	export HISTFILE="$XDG_STATE_HOME/bash/history"
fi

if [[ -f "$HOME/.bashrc" ]]; then
	source "$HOME/.bashrc"
elif [[ -n "$ENV" ]] && [[ -f "$ENV" ]]; then
	source "$ENV"
fi
