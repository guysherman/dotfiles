Plug 'ThePrimeagen/git-worktree.nvim'

function WorktreeSetup()
lua require("guy")
endfunction

augroup WorktreeSetup
    autocmd!
    autocmd User PlugLoaded call WorktreeSetup()
augroup END
nnoremap <leader>wl :lua require("telescope").extensions.git_worktree.git_worktrees()<CR>
nnoremap <leader>wc :lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>

