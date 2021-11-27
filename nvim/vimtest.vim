Plug 'vim-test/vim-test'
let test#strategy = "kitty"

nmap <silent> \tn :TestNearest<CR>
nmap <silent> \tf :TestFile<CR>
nmap <silent> \ts :TestSuite<CR>
nmap <silent> \tl :TestLast<CR>
nmap <silent> \tv :TestVisit<CR>

