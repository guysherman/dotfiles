if executable('ag')
  let g:ackprg = "ag --nogroup --column --ignore '*.jsbundle' --ignore-dir=node_modules"

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor\ --ignore\ '*.jsbundle'\ --ignore-dir=node_modules
endif

" bind <leader>g to grep word under cursor
"nnoremap <leader>g :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
"nnoremap <leader>rw :%s/\<<C-R><C-W>\>/
" show grep results in a new window
"autocmd QuickFixCmdPost *grep* cwindow

nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

nnoremap <leader>[ :cp<cr>zzzv
nnoremap <leader>] :cn<cr>zzzv
nnoremap <leader>` :cclose<cr>

function! s:GrepOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    execute "normal!`<v`>y"
  elseif a:type ==# 'char'
    execute "normal! `[y`]'"
  else
    return
  endif

  silent execute "grep! -R " . shellescape(@@) . " ."
  copen 20

  let @@ = saved_unnamed_register
endfunction
