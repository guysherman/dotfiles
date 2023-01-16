Plug 'vim-test/vim-test'

source $HOME/.config/nvim/plugins/vim-test-config.vim

" VimTest
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

" Borrowed from VimTest itself
function! s:Windows() abort
  return has('win32') && fnamemodify(&shell, ':t') ==? 'cmd.exe'
endfunction

" Borrowed from VimTest itself
function! s:pretty_command(cmd) abort
  let cmds = []
  let separator = !s:Windows() ? '; ' : ' & '

  if !get(g:, 'test#preserve_screen')
    call add(l:cmds, !s:Windows() ? 'clear' : 'cls')
  endif

  if get(g:, 'test#echo_command', 1)
    call add(l:cmds, !s:Windows() ? 'echo -e '.shellescape(a:cmd) : 'Echo '.shellescape(a:cmd))
  endif

  call add(l:cmds, a:cmd)

  return join(l:cmds, l:separator)
endfunction

let s:KittyRunNamespaced = luaeval('require("guy.kitty").KittyRunNamespaced')

function! NamespacedKittyStrategy(cmd)
  let cmd = join(['cd ' . shellescape(getcwd()), s:pretty_command(a:cmd)], '; ')
  call s:KittyRunNamespaced(cmd)
endfunction

let g:test#custom_strategies = {'kitty_namespaced': function('NamespacedKittyStrategy')}
let g:test#strategy = 'kitty_namespaced'
