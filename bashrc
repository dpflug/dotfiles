PATH=${PATH}:~/bin:~/.gem/ruby/1.9.1/bin
export EDITOR="vim"

alias vi='vim'
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias x='startx'
alias ta='tmux a -d > /dev/null || tmux'
alias dps='ssh -t projecthq.biz screen -raAd'


[[ -f /etc/profile.d/bash-completion ]] &&
source /etc/profile.d/bash-completion

shopt -s histappend

if [[ $EUID -gt 1 ]] ; then
	PS1='\[\e[0;33m\][\[\e[1;34m\]\u\[\e[0;33m\]@\[\e[1;33m\]\h \[\e[0;31m\]\w\[\e[0;33m\]]\[\e[0;31m\]\$ \[\e[0m\]'
  eval $(keychain --eval -q ~/.ssh/id_rsa ~/.ssh/cao_key)
fi

#Possible fix for Java window issues in Awesome. I think it's cleaner in xinitrc, though.
#export AWT_TOOLKIT=MToolkit

[[ -a ~/.bashrc_local ]] &&
source ~/.bashrc_local
