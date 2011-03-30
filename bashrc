#!/usr/bin/env bash
PATH=${PATH}:~/bin:~/.gem/ruby/1.9.1/bin
export EDITOR="vim"

alias vi='vim'
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias x='startx'
alias ta='tmux a -d > /dev/null || tmux'
alias dps='ssh -t david@projecthq.biz screen -raAd'
alias awdb='Xephyr -ac -br -noreset -screen 800:600 :1 & export DISPLAY=":1.0" PS1="\[\e[0;31m\]AWDB ${PS1}" ; sleep 2 && awesome &'
alias undb='killall Xephyr ; export DISPLAY=":0.0" PS1=${PS1##*AWDB }'
alias mtr='mtr --curses'
alias myip='elinks -dump checkip.dyndns.org'

[[ -f /etc/profile.d/bash-completion ]] &&
    source /etc/profile.d/bash-completion

shopt -s histappend

# Possible fix for Java window issues in Awesome. I think it's cleaner in xinitrc, though.
#export AWT_TOOLKIT=MToolkit

# Moved this up here so it can be overridden in the bashrc_local
[[ $EUID -gt 1 ]] &&
    export PS1='\[\e[0;33m\][\[\e[1;34m\]\u\[\e[0;33m\]@\[\e[1;33m\]\h \[\e[0;31m\]\w\[\e[0;33m\]]\[\e[0;31m\]\$ \[\e[0m\]'

[[ -a ~/.bashrc_local ]] &&
    source ~/.bashrc_local

if [[ $EUID -gt 1 ]] ; then
    if [[ -x $(which keychain) ]] ; then
        eval $(keychain --eval -q ~/.ssh/id_rsa ~/.ssh/cao_key)
    fi
fi

# Virtualenvwrapper
WORKON_HOME=~/.virtualenvs
[[ -f $(which virtualenvwrapper.sh) ]] &&
    source $(which virtualenvwrapper.sh)
