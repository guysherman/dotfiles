" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data').'/plugged')
	Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
	    \ Plug 'ryanoasis/vim-devicons' |
	    \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

  Plug 'preservim/nerdcommenter'
	Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " this is for auto complete, prettier and tslinting
  Plug 'puremourning/vimspector'
  let g:vimspector_enable_mappings = 'HUMAN'
  let g:vimspector_install_gadgets = ['vscode-node-debug2']

	let g:coc_global_extensions = [
		\ 'coc-tslint-plugin',
		\ 'coc-tsserver',
		\ 'coc-css',
		\ 'coc-html',
		\ 'coc-json',
		\ 'coc-prettier',
		\ 'coc-eslint',
		\ 'coc-sql',
		\ 'coc-jest',
		\ 'coc-highlight',
		\ 'coc-tslint-plugin',
		\ 'coc-sh',
		\ 'coc-yaml',
		\ 'coc-swagger',
    \ 'coc-markdownlint',
    \ 'coc-pyright',
		\ 'coc-docker']  " list of CoC extensions needed

	Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {

	" these two plugins will add highlighting and indenting to JSX and TSX files.
	Plug 'yuezk/vim-js'
	Plug 'HerringtonDarkholme/yats.vim'
	Plug 'maxmellon/vim-jsx-pretty'

	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
  
  Plug 'tpope/vim-fugitive'

  Plug 'hashivim/vim-terraform'
  let g:terraform_align=1
  let g:terraform_fmt_on_save=1

  Plug 'itchyny/lightline.vim'
  let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

  Plug 'moll/vim-bbye'
  Plug 'tpope/vim-surround'

  Plug 'knubie/vim-kitty-navigator'
  Plug 'ruanyl/vim-gh-line'
call plug#end()


