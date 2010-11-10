#!/usr/bin/env zsh
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep nomatch notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dpflug/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
autoload -U promptinit colors
promptinit
colors
prompt walters
PS1="%B%(?..[%?] )%b%{$fg[blue]%}%n%{$reset_color%}@%U%B%m%b%u%{$fg[red]%}%#%{$reset_color%} "

# Setup some key bindings
bindkey -e # This will enable emacs keybindings I'm "used" to.
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

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
alias chroothere='sudo mount -R /dev dev && sudo mount -t proc{,,} && sudo mount -t sys{fs,fs,} && sudo chroot . /bin/bash ; sudo umount dev/* dev sys proc'

[[ -a ~/.zshrc_local ]] &&
source ~/.zshrc_local

if [[ $EUID > 1 ]] ; then
    if [[ -x $(which keychain) ]] ; then
        eval $(keychain --eval -q ~/.ssh/id_rsa ~/.ssh/cao_key)
    fi
fi
