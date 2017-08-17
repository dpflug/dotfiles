#!/usr/bin/env bash

#Ok, this is quick and hackish.

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    REPODIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$REPODIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
REPODIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
unset CDPATH

git submodule update --init

if [[ ! -d ~/.config ]] ; then
    mkdir ~/.config
fi

cd "${REPODIR}"/config
find ./* -maxdepth 0 -type d | while read directory ; do
    if [[ ! -a ~/.config/"${directory#./}" ]] ; then
        echo "Linking ${REPODIR}/config/${directory#./} to ~/.config/"
        #ln -s "${REPODIR}/config/${directory#./}" ~/config/
    fi
done
cd - > /dev/null

if [[ ! -d ~/.ssh ]] ; then
    mkdir ~/.ssh
fi

cd "${REPODIR}"/ssh
find ./* -maxdepth 0 -type f | while read file ; do
    if [[ -f ${file}.pub ]] ; then
        chmod 600 "$file" "${file}".pub
    fi
    bfile=$(basename "${file}")
    if [[ ! -a ~/.ssh/$basefile ]] ; then
        echo "Linking ${REPODIR}/ssh/$bfile to ~/.ssh/"
        ln -s "${REPODIR}/ssh/$bfile" ~/.ssh/
    fi
done
cd - > /dev/null

if [[ ! -d ~/bin ]] ; then
    ln -s "${REPODIR}"/bin ~/bin
else
    find "${REPODIR}"/bin/* -maxdepth 0 -type f | while read file ; do
        if [[ ! -a ~/bin/$(basename "${file}") ]] ; then
            ln -s "$file" ~/bin/
        fi
    done
fi

if [[ ! -d ~/.gnupg ]] ; then
    mkdir ~/.gnupg
fi

ln -s "${REPODIR}"/gunpg/gpg.conf ~/.gnupg/

if [[ ! -d ~/.vim ]] ; then
    ln -s "$REPODIR"/vim ~/.vim
elif [[ ! -h ~/.vim ]] ; then
    echo "~/.vim ALREADY EXISTS. Either delete it or merge them."
fi

# Install Vundle
if [[ ! -d $REPODIR/vim/bundle/vundle ]] ; then
    git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
fi

find "${REPODIR}"/* -maxdepth 0 | while read file ; do
    #Just omitting the directories for now. I'd like to pull them into this loop, too, though.
    #mkdir and ln files, or ln directories? How can I differentiate between dirs to link and dirs that will have local subdirs (ie .config)?
    if [[ -f $file && ! -x $file ]] ; then
        bfile=$(basename "$file")
        if [[ ! -a ~/."$bfile" ]] ; then
            echo "Linking $file to ~/.$bfile"
            ln -s "${file}" ~/."$bfile"
        fi
    fi
done
