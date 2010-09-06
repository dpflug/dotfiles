set nocompatible
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smarttab
set autoindent
set smartindent
"set cindent
set foldmethod=marker
set backupdir=~/.vim/backups/,.,/tmp

set spelllang=en_us
set spellfile=~/.vim/spellfile.add

syntax enable

"Make Crtl-L clear search highlights
nmap <silent> <C-l> :nohl<CR><C-l>

au BufNewFile,BufRead *.t2t set ft=txt2tags
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
