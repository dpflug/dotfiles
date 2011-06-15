set nocompatible

" Colorscheme I like
colorscheme maroloccio
" It's 256 color, so I'll force that. In the rare case it causes problems,
" unset by hand.
set t_Co=256

" Whip the tabs into shape
set shiftwidth=4
set softtabstop=4
" Let's see where there may be some tabs.
"set tabstop=4
set expandtab
set smarttab

" syntax highlighting
syntax on

" Setting ident options is deprecated in favor of allowed the language detection to setup indentation rules
" This allows more flexible/intelligent indentation options.
" See :help 30.3
"set smartindent
"set cindent
filetype indent plugin on

" This allows you to switch to other buffers without saving. This is important when working in multiple files.
set hidden

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Ignore case while searching, except when caps are entered.
set ignorecase
set smartcase

" Autoindent when no filetype's set
set autoindent

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Tell me where in the file I am
set ruler

" Always display the status line
set laststatus=2

" F11 to toggle between paste and nopaste
set pastetoggle=<F11>

" Folding
set foldmethod=marker

set backupdir=~/.vim/backups/,.,/tmp

" Spell checking
set spelllang=en_us
set spellfile=~/.vim/spellfile.add

" Make Crtl-L clear search highlights
nmap <silent> <C-l> :nohl<CR>

" txt2tags support
au BufNewFile,BufRead *.t2t set ft=txt2tags

" Python smart indent
autocmd BufRead *.py set colorcolumn=79

" Lilypond support
filetype off
set runtimepath+=/usr/share/lilypond/2.12.3/vim/
filetype on

" I shouldn't encounter any slow TTYs
set ttyfast
