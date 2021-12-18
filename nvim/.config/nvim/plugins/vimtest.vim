Plug 'vim-test/vim-test'
let test#strategy = "kitty"
let test#javascript#jest#executable = "yarn test"
let test#javascript#reactscripts#executable = "yarn test"

" VimTest
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>
