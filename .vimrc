" Surround entire file with vscode check, so we can use the
" embedded neovim vscode extension
if !exists('g:vscode')

set nocompatible

" Whip the tabs into shape
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smarttab

" Set up plug


" Enable vim-plug, for plugins
if has('win32')
    call plug#begin($APPDATA . '/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

"""""" My bundles
Plug 'vim-airline/vim-airline'          " Pretty status bar
Plug 'jiangmiao/auto-pairs'             " Auto-close paired characters
Plug 'preservim/nerdtree'               " Directory browser
Plug 'Maroloccio/maroloccio-vim'	" Color scheme
Plug 'gko/vim-coloresque'		" Show colors in CSS/HTML/LESS/SASS
Plug 'docunext/closetag.vim'		" Close HTML tags
Plug 'ziglang/zig.vim'
if v:version >= 703
    Plug 'Yggdroot/indentLine'		" Add lines to show indent level
endif
if v:version >= 704
    Plug 'vim-pandoc/vim-pandoc-syntax'
endif

" Lisp REPL/niceties
if v:version >= 800
    Plug 'vlime/vlime'
    Plug 'kovisoft/paredit'
    let g:vlime_leader = ","
else
    Plug 'kovisoft/slimv'
endif

" Linting/checking
if v:version >= 800
    Plug 'dense-analysis/ale'

    let g:ale_python_mypy_options = '--strict'
    let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'c': ['clang-format', 'clangtidy'],
    \}
    if executable('goimports')
        let g:ale_fixers['go'] = ['goimports']
    else
        let g:ale_fixers['go'] = ['gofmt']
    endif
    if executable('black')
        let g:ale_fixers['python'] = ['black']
    endif
    if executable('shfmt')
        let g:ale_fixers['sh'] = ['shfmt']
    endif

    if !exists('g:ale_linters')
        let g:ale_linters = {}
    endif
    if executable('gopls')
        let g:ale_linters['go'] = ['gopls']
    endif
    let g:ale_fix_on_save = 1
else
    Plug 'vim-syntastic/syntastic'

    set statusline+=%#warningmsg$
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:synastic_always_populate_loc_list = 1
    let g:synastic_auto_loc_list = 1
    let g:synastic_check_on_open = 1
    let g:synastic_check_on_wq = 0
endif

" Completion
if v:version >= 800
    Plug 'Shougo/deoplete.nvim'
    if !has('nvim')
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
else
    Plug 'ervandew/supertab'
endif

" LSP support
if v:version >= 800
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'lighttiger2505/deoplete-vim-lsp'
endif

Plug 'Omer/vim-sparql'

if filereadable("~/.vimrc_local_plug")
    source "~/.vimrc_local_plug"
endif

" Be finished with vim-plug
call plug#end()

" Colorscheme I like
colorscheme maroloccio
" It's 256 color, so I'll force that. In the rare case it causes problems,
" unset by hand.
set t_Co=256

" Lilypond support
set runtimepath+=/usr/share/lilypond/*/vim

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

if v:version >= 703
    " Python and git commit line length indicators
    autocmd FileType python set colorcolumn=72,79
    autocmd FileType gitcommit set colorcolumn=50
endif

" Python completion
autocmd FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"

" Add pydoc and menu for completion
set completeopt=menuone,longest,preview

" HTML tag closing
autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim

if v:version >= 703
    " Relative line numbers can be helpful for navigation
    set rnu

    if !has('nvim')
        " Stronger encryption
        set cryptmethod=blowfish
    endif
endif

" I shouldn't encounter any slow TTYs
set ttyfast

" Show end of line whitespace, tabs
" For some reason, this isn't working for me within tmux.
if has("multi_byte")
    if &termencoding == ''
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8 nobomb
    set fileencodings=utf-8,latin1
    set list listchars=tab:▸\ ,trail:·
else
    set list listchars=trail:-,tab:>-
endif

" Sometimes I open files, then decide I want to make changes when I don't have
" the permissions.
cmap w!! %!sudo tee > /dev/null %

" How many times have I typoed this?
command! W w
command! Wq wq
command! WQ wq

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

if filereadable("~/.vimrc_local")
    source "~/.vimrc_local"
endif
endif
