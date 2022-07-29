" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-jdtls'
Plug 'williamboman/nvim-lsp-installer'
Plug 'creativenull/diagnosticls-configs-nvim'
Plug 'scalameta/nvim-metals'
Plug 'onsails/lspkind-nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

function LSPSetup()
  lua require('guy.lsp')
  lua require('guy.nvim-metals-config')
endfunction

augroup LSPSetup
    autocmd!
    autocmd User PlugLoaded call LSPSetup()
augroup END
