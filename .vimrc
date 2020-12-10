set mouse=a
set autoindent
set smartindent
syntax on
set tabstop=2
set number
set shiftwidth=2
set smarttab
set expandtab
set clipboard=unnamed
set clipboard=unnamedplus
set linebreak
filetype on
filetype plugin indent on
colorscheme darkblue
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,php,ruby,python autocmd
        \ BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre Makefile :call <SID>StripTrailingWhitespaces()
noremap! <C-?> <C-h>
