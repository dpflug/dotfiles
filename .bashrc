#!/usr/bin/env bash
if [[ -e ~/.commonrc ]]; then
	# shellcheck source=/home/dpflug/.commonrc
	source ~/.commonrc
fi

if [[ -f /etc/profile.d/bash-completion ]]; then
	source /etc/profile.d/bash-completion
fi

shopt -s histappend

# Possible fix for Java window issues in Awesome. I think it's cleaner in xinitrc, though.
#export AWT_TOOLKIT=MToolkit

if [[ $EUID -gt 1 ]]; then
	export PS1='\[\e[0;33m\][\[\e[1;34m\]\u\[\e[0;33m\]@\[\e[1;33m\]\h \[\e[0;31m\]\w\[\e[0;33m\]]\[\e[0;31m\]\$ \[\e[0m\]'
fi

if [[ -e ~/.bashrc_local ]]; then
	# shellcheck source=/home/dpflug/.bashrc_local
	source ~/.bashrc_local
fi
