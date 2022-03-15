Plug 'MunifTanjim/nui.nvim'
"Plug '~/source/postgres-nvim'
Plug 'guysherman/pg.nvim'

vnoremap <leader>qq :<c-u>exec "PGRunQuery"<cr>
nnoremap <leader>qc :PGConnectBuffer<cr>
