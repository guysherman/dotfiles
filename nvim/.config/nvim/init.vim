let mapleader="\<Space>"
set runtimepath^=~/.vim runtimepath+=~/.vim/after 
set runtimepath +=~/dotfiles/nvim/.config/nvim
let &packpath = &runtimepath

syntax enable
set background=dark
set clipboard+=unnamedplus

colorscheme monokai-soda

source ~/dotfiles/nvim/.config/nvim/plugins.vim
source ~/dotfiles/nvim/.config/nvim/config/clang_format.vim
source ~/dotfiles/nvim/.config/nvim/config/cpp_format.vim

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
"
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

autocmd FileType c,cpp,javascript,typescript,javascriptreact,typescriptreact,json setlocal foldmethod=syntax
autocmd FileType c,cpp,javascript,typescript,javascriptreact,typescriptreact,json,yaml setlocal nofoldenable


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

set errorformat+=%f(%l\\,%c):%m
nnoremap <leader>tt :cexpr! system('tsc --noEmit') <cr>:copen 20<cr>
nnoremap <leader>RR :bufdo e<cr>

" Make Y behave the same as all the other capital letters (ie do the whole line)
nnoremap Y yg$

" When jumping around, keep the line in the middle of the screen
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Break up the undo sequence when we type certain characters
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap [ [<c-g>u
inoremap ( (<c-g>u
inoremap { {<c-g>u

" Make c-o and c-i observe multi-line jumps
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Moving lines around
vnoremap J :m '>+1'<CR>gv=gv
vnoremap K :m '<-2'<CR>gv=gv
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Buffer list stuff
nnoremap <leader>bda :%bd<CR>
