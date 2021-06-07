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

  let g:sw_exe = "/home/guy/.local/share/sqlworkbenchj/sqlwbconsole.sh"
  let g:sw_config_dir = '/home/guy/.sqlworkbench'
  let g:sw_cache = '/home/guy/.sqlworkbench/cache'
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
		\ 'coc-docker']  " list of CoC extensions needed

	Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {

	" these two plugins will add highlighting and indenting to JSX and TSX files.
	Plug 'yuezk/vim-js'
	Plug 'HerringtonDarkholme/yats.vim'
	Plug 'maxmellon/vim-jsx-pretty'

	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'


call plug#end()


