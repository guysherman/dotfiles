Plug 'lervag/wiki.vim'
Plug 'lervag/lists.vim'

let g:wikiw_root = '~/Documents/notes'
let g:wiki_filetypes = ['md']
let g:wiki_link_extension = '.md'

let g:lists_filetypes = ['md']


nnoremap <leader>wj :WikiJournal<CR>
nnoremap <leader>wjj :WikiJournalNext<CR>
nnoremap <leader>wjk :WikiJournalPrev<CR>
nnoremap <leader>wjw :WikiJournalToWeek<CR>
nnoremap <leader>wjm :WikiJournalToMonth<CR>
nnoremap <leader>wji :WikiJournalIndex<CR>
nnoremap <leader>wjc :WikiJournalCopyToNext<CR>


