set runtimepath^=~/.vim runtimepath+=~/.vim/after 
let &packpath = &runtimepath

syntax enable
set background=dark

colorscheme monokai-soda

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/nerdtree.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/terminal.vim
source ~/.config/nvim/fzf.vim.vim
source ~/.config/nvim/grep.vim

set smartindent
set backupcopy=yes
" show existing tab with 2 spaces width
set tabstop=2
set shiftwidth=2
set expandtab
set nowrap
"if we use a capital it will look for case sensitive
set ignorecase
set smartcase
set showmatch
set linespace=0
set relativenumber
set number
set scrolloff=3
"yank to clipboard
set clipboard+=unnamed
"allow use to use bash
set nospell


syntax on
filetype on

set suffixesadd+=.vue

"set all .es6 files to be javascript files
au bufnewfile,bufread *.es6 set filetype=javascript
au BufNewFile,BufRead *.flow set filetype=javascript
au BufNewFile,BufRead *.vue set filetype=javascript
au BufNewFile,BufRead *Dockerfile* set filetype=dockerfile


" Persistent undo
set undofile

set undolevels=1000
set undoreload=10000

nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
vnoremap <Left> <nop>
vnoremap <Right> <nop>
vnoremap <Up> <nop>
vnoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>

