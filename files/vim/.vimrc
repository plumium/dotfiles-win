set encoding=utf-8

set number
set cursorline
highlight clear CursorLine
set showcmd
set showmatch
set scrolloff=5

set ignorecase
set hlsearch
set incsearch

set splitbelow

set wildmenu
set wildmode=longest,list,full

set expandtab
set tabstop=4
set shiftwidth=0

syntax enable
set t_Co=256

let &t_SI .= "\<Esc>[5 q"
let &t_EI .= "\<Esc>[1 q"

nnoremap <silent> <F5> :source $MYVIMRC<CR>
nnoremap <silent> <Esc><Esc> :noh<CR>
nnoremap <silent> <Space><Space> :let @/ = '\<' . expand('<cword>') . '\>'<CR>:set hlsearch<CR>
nnoremap <silent> <Space>r :reg<CR>
nnoremap <silent> <Space>m :marks<CR>
nnoremap <silent> <Space>t :tags<CR>
nnoremap x "_x
nnoremap s "_s

nmap <C-h> <Space><Space>:%s/<C-r>///g<Left><Left>
