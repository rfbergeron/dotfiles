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
# shellcheck disable=SC2034
WHITE='\[\e[0;97m\]'
# this is bright black, not dark black
BOLDBLACK='\[\e[1;90m\]'
# shellcheck disable=SC2034
BLACK='\[\e[0;90m\]'
NC='\[\e[0m\]'

if [[ $LIGHT_BG -gt 0 ]]; then
	ACCENTCOLOR=$BOLDBLACK
else
	ACCENTCOLOR=$BOLDWHITE
fi

# set the prompt
prompt() {
	local LAST_STATUS=$?
	if [[ $LAST_STATUS -gt 0 ]]; then
		local STATUS_COLOR="$BOLDRED"
	else
		local STATUS_COLOR="$ACCENTCOLOR"
	fi

	if [[ -n $SSH_TTY || $FULLPROMPT -gt 0 ]]; then
		local USER_AND_HOST="$NC\u$ACCENTCOLOR@$NC\h"
	fi
	PS1="$USER_AND_HOST$STATUS_COLOR\$ $NC"
	PS2="$ACCENTCOLOR>$NC "
	PS4="$NC+ "
}

PROMPT_COMMAND=prompt

# resize window after command, if necessary
shopt -s checkwinsize

# append history to $HISTFILE on exit instead of overwriting it
shopt -s histappend

# expand directory paths when completing
shopt -s direxpand
