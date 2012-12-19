#!/usr/bin/env zsh
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd beep correctall dvorak interactive_comments nomatch notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dpflug/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Pretty prompts
autoload -U promptinit colors
promptinit
colors
prompt walters
PS1="%B%(?..[%?] )%b%{$fg[blue]%}%n%{$reset_color%}@%U%B%m%b%u%{$fg[red]%}%#%{$reset_color%} "

# Fuzzy matching of completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)' # Adjust number of errors allowed based on length of typed characters.
zstyle ':completion:*:functions' ignored-patterns '_*' # Ignore completion for I don't have.
# Completing process IDs with menu selection:
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

## Setup some key bindings
#bindkey -e # This will enable emacs keybindings I'm "used" to.
#bindkey "\e[5~" beginning-of-history
#bindkey "\e[6~" end-of-history
#bindkey "\e[3~" delete-char
#bindkey "\e[2~" quoted-insert
#bindkey "\e[5C" forward-word
#bindkey "\eOc" emacs-forward-word
#bindkey "\e[5D" backward-word
#bindkey "\eOd" emacs-backward-word
#bindkey "\e\e[C" forward-word
#bindkey "\e\e[D" backward-word

# Let's give vim mode a try
#bindkey -v
# Decided c-x c-e is a better idea.

# These make me feel like I'm doing it wrong, maybe... >.>
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "^r" history-incremental-pattern-search-backward
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

if [[ -f /etc/bash_completion.d/virtualenvwrapper && ! -f $(which virtualenvwrapper.sh) ]] ; then # -.- Ubuntu
    WORKON_HOME=~/.virtualenvs
    source /etc/bash_completion.d/virtualenvwrapper
fi

if [[ -a ~/.commonrc ]] ; then
    source ~/.commonrc
fi

if [[ -a ~/.zshrc_local ]] ; then
    source ~/.zshrc_local
fi
