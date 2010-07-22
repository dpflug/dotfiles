#!/usr/bin/env bash

#Ok, this is quick and hackish.
if [[ -a ~/.config/awesome ]] ; then
    echo "~/.config/awesome exists"
else
    echo "Linking ~/.config/awesome"
    ln -s ~/Public/dotfiles/config/awesome ~/.config/awesome
fi

cd ~/Public/dotfiles/ssh
for file in * ; do
    if [[ -a ~/.ssh/${file} ]] ; then
        echo "~/.ssh/${file} exists"
    else
        echo "Linking ~/Public/dotfiles/ssh/${file} to ~/.ssh/"
        ln -s ~/Public/dotfiles/${file} ~/.ssh/
    fi
done


for file in ~/Public/dotfiles/ ; do
    #Just omitting the directories for now. I'd like to pull them into this loop, too, though.
    #mkdir and ln files, or ln directories? How can I differentiate between dirs to link and dirs that will have local subdirs (ie .config)?
    if [[ -f $file ]] ; then
        if [[ -a ~/.${file} ]] ; then
            echo "~/.${file} exists"
        else
            echo "Linking ~/Public/dotfiles/${file} to ~/.${file}"
            ln -s ~/Public/dotfiles/${file} ~/.${file}
        fi
    fi
done
