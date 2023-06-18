" LSP Support
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-jdtls'
Plug 'creativenull/diagnosticls-configs-nvim'
Plug 'scalameta/nvim-metals'
Plug 'onsails/lspkind-nvim'

"  Snippets
"Plug 'L3MON4D3/LuaSnip'
Plug 'dcampos/nvim-snippy'
Plug 'honza/vim-snippets'
Plug 'dcampos/cmp-snippy'
"Plug 'rafamadriz/friendly-snippets'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
"Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'


function LSPSetup()
  lua require('guy.lsp')
  lua require('guy.nvim-metals-config')
endfunction

augroup LSPSetup
    autocmd!
    autocmd User PlugLoaded call LSPSetup()
augroup END
