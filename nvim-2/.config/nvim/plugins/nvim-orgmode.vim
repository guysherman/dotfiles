Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-orgmode/orgmode'

function OrgModeSetup()
lua require("guy")
endfunction

augroup OrgModeSetup
    autocmd!
    autocmd User PlugLoaded call OrgModeSetup()
augroup END

