#!/usr/bin/env zsh

# Ensure GPG prompts here
GPG_TTY=$(tty)
export GPG_TTY

# Keychain
if [ "$EUID" -gt 1 ] || [ "$(id -u)" -gt 1 ]; then
	if [ -f "$(command -v keychain)" ]; then
		ssh_keys=$(find ~/.ssh -name id_\* -and \! -name \*.pub)
		#gpg_keys=$(gpg -K | grep 'sec ' | awk '{ print $2 }' | cut -d'/' -f 2)
		gpg_keys=""
		eval "$(keychain --eval -q "$ssh_keys" "$gpg_keys")"
		unset gpg_keys
		unset ssh_keys
	fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd beep correctall dvorak interactive_comments nomatch notify extendedglob
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dpflug/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Make concessions for emacs' TRAMP
if [[ "$TERM" == "dumb" ]] ; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

# Pretty prompts
if [ -r "${HOME}/.local/share/yadm_submodules/powerlevel10k" ] ; then
    source "${HOME}/.local/share/yadm_submodules/powerlevel10k/powerlevel10k.zsh-theme"
else
    autoload -U promptinit colors
    promptinit
    colors
    prompt walters
    PS1="%B%(?..[%?] )%b%{$fg[blue]%}%n%{$reset_color%}@%U%B%m%b%u%{$fg[red]%}%#%{$reset_color%} "
fi

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
