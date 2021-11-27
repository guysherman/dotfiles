	Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " this is for auto complete, prettier and tslinting

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

