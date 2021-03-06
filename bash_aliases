#
# ~/.bash_aliases
#

# Define a few Colors
BLACK='\[\e[0;30m\]'
BLUE='\[\e[0;34m\]'
GREEN='\[\e[0;32m\]'
CYAN='\[\e[0;36m\]'
RED='\[\e[0;31m\]'
PURPLE='\[\e[0;35m\]'
BROWN='\[\e[0;33m\]'
LIGHTGRAY='\[\e[0;37m\]'
DARKGRAY='\[\e[1;30m\]'
LIGHTBLUE='\[\e[1;34m\]'
LIGHTGREEN='\[\e[1;32m\]'
LIGHTCYAN='\[\e[1;36m\]'
LIGHTRED='\[\e[1;31m\]'
LIGHTPURPLE='\[\e[1;35m\]'
YELLOW='\[\e[1;33m\]'
WHITE='\[\e[1;37m\]'
NC='\[\e[0m\]'

# Useful things
alias ls='ls -h --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias dmesg='dmesg -H --color=auto'
alias xcopy='xclip -selection clipboard'
alias xpaste='xclip -o -selection clipboard'
alias info='info --vi-keys'

# Force myself to use the good shit
which --skip-alias nvim &>/dev/null && alias vim='nvim'

# set the prompt
prompt () {
    local STATUS=$(if [[ $? -gt 0 ]]; \
                   then echo -e "$RED"; \
                   else echo -e "$WHITE"; \
                   fi)
    local SSH_IP=$(echo $SSH_CLIENT | awk '{ print $1 }')
    local SSH2_IP=$(echo $SSH2_CLIENT | awk '{ print $1 }')
    if [[ -n $SSH2_IP ]] || [[ -n $SSH_IP ]] ; then
        local USER_AND_HOST="$NC\u$WHITE@$NC\h "
    fi
    PS1="$USER_AND_HOST$STATUS\$ $NC"
    PS2="$WHITE>$NC "
    PS4=" $NC "
}

# Extract things. Thanks to urukrama, ubuntuforums.org	
# I use unrar instead of rar
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1    ;;
             *.tar.gz)    tar xzf $1    ;;
             *.bz2)       bunzip2 $1    ;;
             *.rar)       unrar x $1    ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1     ;;
             *.tbz2)      tar xjf $1    ;;
             *.tgz)       tar xzf $1    ;;
             *.zip)       unzip $1      ;;
             *.Z)         uncompress $1 ;;
             *.7z)        7z x $1       ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# A PATH environment variable editor
# From apmcd47 on ubuntuforums, and the guy that actually
# wrote it and gave it to him
vipath () { 
    declare TFILE=/tmp/path.$LOGNAME.$$;
    echo $PATH | sed 's/^:/.:/;s/:$/:./' | sed 's/::/:.:/g' | tr ':' '\012' > $TFILE;
    vim $TFILE;
    PATH=`awk ' { if (NR>1) printf ":"
      printf "%s",$1 }' $TFILE`;
    rm -f $TFILE;
    echo $PATH
}  
