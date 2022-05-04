Plug 'lervag/wiki.vim'

let g:wikiw_root = '~/Amazon WorkDocs Drive/My Documents/notes'
let g:wiki_filetypes = ['md']
let g:wiki_link_extension = '.md'

nnoremap <leader>wlf :WikiLinkFollow<CR>
nnoremap <leader>wlj :WikiLinkNext<CR>
nnoremap <leader>wlk :WikiLinkPrev<CR>

nnoremap <leader>wj :WikiJournal<CR>
nnoremap <leader>wjj :WikiJournalNext<CR>
nnoremap <leader>wjk :WikiJournalPrev<CR>
nnoremap <leader>wjw :WikiJournalToWeek<CR>
nnoremap <leader>wjm :WikiJournalToMonth<CR>
nnoremap <leader>wji :WikiJournalIndex<CR>
nnoremap <leader>wjc :WikiJournalCopyToNext<CR>


