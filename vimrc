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

" Enable Pathogen, with all the bundles I have installed
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Lilypond support
filetype off
set runtimepath+=/usr/share/lilypond/2.12.3/vim/

" Setting ident options is deprecated in favor of allowed the language detection to setup indentation rules
" This allows more flexible/intelligent indentation options.
" See :help 30.3
"set smartindent
"set cindent
filetype indent plugin on

" This allows you to switch to other buffers without saving.
set hidden

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Incremental search
set incsearch

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

" HTML tag closing
autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim

" Relative line numbers can be helpful for navigation
set rnu

" I shouldn't encounter any slow TTYs
set ttyfast

" Show end of line whitespace
set list listchars=trail:·

" Sometimes I open files, then decide I want to make changes when I don't have
" the permissions.
cmap w!! %!sudo tee > /dev/null %

" How many times have I typoed this?
command! W w

" Store more history
set history=100

" Keep some lines between cursor and screen edge
set scrolloff=4
set sidescrolloff=6

" Let's make navigating wrapped lines easier
nnoremap  <Up>    gk
nnoremap  <Down>  gj
inoremap  <Up>    <C-O>gk
inoremap  <Down>  <C-O>gj

" send stuff to xclip (because I don't like vim messing with my clipboard
" automatically)
map ,c :w !xclip<CR><CR>
vmap ,c '<,'>w !xclip<CR><CR>

" Pastebin my crap
if exists("$DISPLAY")
    map ,pb :w !curl -sF 'sprunge=<-' http://sprunge.us \| tee /dev/stderr \| xclip<CR>
    vmap ,pb '<,'>w !curl -sF 'sprunge=<-' http://sprunge.us \| tee /dev/stderr \| xclip<CR>
else
    map ,pb :w !curl -sF 'sprunge=<-' http://sprunge.us<CR>
    vmap ,pb '<,'>w !curl -sF 'sprunge=<-' http://sprunge.us<CR>
endif
