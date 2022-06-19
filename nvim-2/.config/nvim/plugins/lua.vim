Plug 'nvim-lua/plenary.nvim' " don't forget to add this one if you don't have it yet!
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

function TreesitterSetup()
lua require("guy.treesitter")
endfunction

augroup TreesitterSetup
    autocmd!
    autocmd User PlugLoaded call TreesitterSetup()
augroup END


