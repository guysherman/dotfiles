Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

function TelescopeSetup()
lua require("guy")
endfunction

augroup TelescopeSetup
    autocmd!
    autocmd User PlugLoaded call TelescopeSetup()
augroup END

nnoremap <C-A> :lua require('telescope.builtin').find_files({ hidden = true })<CR>
nnoremap <C-F> :lua require('telescope.builtin').live_grep()<CR>
nnoremap <C-P> :lua require('telescope.builtin').git_files()<CR>
nnoremap <C-B> :lua require('telescope.builtin').buffers({sort_lastused = true})<CR>
