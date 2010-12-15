#!/usr/bin/env bash

#Ok, this is quick and hackish.

REPODIR=$(pwd)

if [[ ! -d ~/.config ]] ; then
    mkdir ~/.config
fi

if [[ -a ~/.config ]] ; then
    if [[ ! -a ~/.config/awesome ]] ; then
        echo "Linking ~/.config/awesome"
        ln -s ${REPODIR}/config/awesome ~/.config/awesome
    fi
fi

if [[ ! -d ~/.ssh ]] ; then
    mkdir ~/.ssh
fi

cd ${REPODIR}/ssh
for file in $(find * -maxdepth 0 -type f) ; do
    if [[ -f ${file}.pub ]] ; then
        chmod 600 $file ${file}.pub
    fi
    if [[ ! -a ~/.ssh/${file} ]] ; then
        echo "Linking ${REPODIR}/ssh/${file} to ~/.ssh/"
        ln -s ${REPODIR}/ssh/${file} ~/.ssh/
    fi
done

if [[ ! -d ~/bin ]] ; then
    ln -s ${REPODIR}/bin ~/bin
else
    for file in ${REPODIR}/bin/* ; do
        if [[ ! -a ~/bin/$(basename ${file}) ]] ; then
            ln -s $file ~/bin/
        fi
    done
fi

if [[ ! -d ~/.vim ]] ; then
    ln -s $REPODIR/vim ~/.vim
elif [[ ! -h ~/.vim ]] ; then
    echo "~/.vim ALREADY EXISTS. Either delete it or merge them."
fi


for file in ${REPODIR}/* ; do
    #Just omitting the directories for now. I'd like to pull them into this loop, too, though.
    #mkdir and ln files, or ln directories? How can I differentiate between dirs to link and dirs that will have local subdirs (ie .config)?
    if [[ -f $file && ! -x $file ]] ; then
        if [[ ! -a ~/.$(basename ${file}) ]] ; then
            echo "Linking ${file} to ~/.$(basename ${file})"
            ln -s ${file} ~/.$(basename ${file})
        fi
    fi
done
