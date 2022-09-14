" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data').'/plugged')
  source $HOME/.config/nvim/plugins/lua.vim
  source $HOME/.config/nvim/plugins/nvim-dap.vim
  "source $HOME/.config/nvim/plugins/vimspector.vim
  source $HOME/.config/nvim/plugins/refactoring.vim

  " Editing Enhancements
  source $HOME/.config/nvim/plugins/nerdcommenter.vim
  source $HOME/.config/nvim/plugins/auto-pairs.vim
  source $HOME/.config/nvim/plugins/vim-surround.vim
  
  "Syntax Highlighting
  source $HOME/.config/nvim/plugins/vim-js.vim
  source $HOME/.config/nvim/plugins/yats.vim
  source $HOME/.config/nvim/plugins/vim-jsx-pretty.vim
  source $HOME/.config/nvim/plugins/vim-cpp-modern.vim
  source $HOME/.config/nvim/plugins/vim-terraform.vim

  " Language Tooling
  "source $HOME/.config/nvim/plugins/coc.vim
  source $HOME/.config/nvim/plugins/lsp.vim
  source $HOME/.config/nvim/plugins/markdown-preview.nvim.vim
  source $HOME/.config/nvim/plugins/vim-yaml-folds.vim
  "source $HOME/.config/nvim/plugins/vim-clang-format.vim
  source $HOME/.config/nvim/plugins/arduino.vim
  
  " Navigation / Search
  source $HOME/.config/nvim/plugins/nerdtree.vim
  source $HOME/.config/nvim/plugins/telescope.vim
  source $HOME/.config/nvim/plugins/grep.vim
  source $HOME/.config/nvim/plugins/harpoon.vim
  "source $HOME/.config/nvim/plugins/vim-rooter.vim
  source $HOME/.config/nvim/plugins/vim-kitty-navigator.vim
  source $HOME/.config/nvim/plugins/vim-bbye.vim
  
  " Source Control
  source $HOME/.config/nvim/plugins/vim-gh-line.vim
  source $HOME/.config/nvim/plugins/vimfugitive.vim
  source $HOME/.config/nvim/plugins/git-worktree.vim

  " Look and feel
  source $HOME/.config/nvim/plugins/lightline.vim
  source $HOME/.config/nvim/plugins/indentline.vim
  source $HOME/.config/nvim/plugins/vimtest.vim
  
  " Databases
  source $HOME/.config/nvim/plugins/postgres-nvim.vim

  " Extra
  source $HOME/.config/nvim/plugins/vim-wiki.vim
call plug#end()

doautocmd User PlugLoaded


