Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

function NvimTreeSetup()
  lua require('guy.nvim-tree')
endfunction


augroup NvimTreeSetup
    autocmd!
    autocmd User PlugLoaded call NvimTreeSetup()
augroup END

