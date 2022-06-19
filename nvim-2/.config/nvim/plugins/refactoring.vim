Plug '/home/guy/source/refactoring.nvim'

function RefactoringSetup()
  lua require('guy.refactoring')
endfunction

augroup RefactoringSetup
  autocmd!
  autocmd User PlugLoaded call RefactoringSetup()
augroup END
