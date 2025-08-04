# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# source posix sh stuff
if [[ -n "$ENV" ]] && [[ -f "$ENV" ]]; then
	source "$ENV"
fi

# define a few colors
BOLDRED='\[\e[1;31m\]'
# this is bright white, not dark white
BOLDWHITE='\[\e[1;97m\]'
WHITE='\[\e[0;97m\]'
# this is bright black, not dark black
BOLDBLACK='\[\e[1;90m\]'
BLACK='\[\e[0;90m\]'
NC='\[\e[0m\]'

# set the prompt
prompt() {
	local LAST_STATUS=$?
	local STATUS_COLOR
	local PROMPT_COLOR
	STATUS_COLOR=$(if [[ $LAST_STATUS -gt 0 ]]; then
		echo -e "$BOLDRED"
	elif [[ $LIGHT_BG -gt 0 ]]; then
		echo -e "$BOLDBLACK"
	else
		echo -e "$BOLDWHITE"
	fi)
	PROMPT_COLOR=$(if [[ $LIGHT_BG -gt 0 ]]; then
		echo -e "$BLACK"
	else
		echo -e "$WHITE"
	fi)
	if [[ -n $SSH_TTY ]]; then
		local USER_AND_HOST="$NC\u$PROMPT_COLOR@$NC\h "
	fi
	PS1="$USER_AND_HOST$STATUS_COLOR\$ $NC"
	PS2="$PROMPT_COLOR>$NC "
	PS4="$NC+ "
}

PROMPT_COMMAND=prompt

# resize window after command, if necessary
shopt -s checkwinsize

# append history to $HISTFILE on exit instead of overwriting it
shopt -s histappend

# expand directory paths when completing
shopt -s direxpand
