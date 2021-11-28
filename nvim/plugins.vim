" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data').'/plugged')
  source ~/dotfiles/nvim/nerdtree.vim
  source ~/dotfiles/nvim/nerdcommenter.vim
  source ~/dotfiles/nvim/vimspector.vim
  source ~/dotfiles/nvim/coc.vim
  source ~/dotfiles/nvim/auto-pairs.vim

	" these two plugins will add highlighting and indenting to JSX and TSX files.
  source ~/dotfiles/nvim/vim-js.vim
  source ~/dotfiles/nvim/yats.vim
  source ~/dotfiles/nvim/vim-jsx-pretty.vim

  source ~/dotfiles/nvim/fzf.vim.vim

  source ~/dotfiles/nvim/vimfugitive.vim
  source ~/dotfiles/nvim/vim-terraform.vim

  source ~/dotfiles/nvim/lightline.vim
  source ~/dotfiles/nvim/vim-bbye.vim
  source ~/dotfiles/nvim/vim-surround.vim
  source ~/dotfiles/nvim/vim-kitty-navigator.vim
  source ~/dotfiles/nvim/vim-gh-line.vim
  source ~/dotfiles/nvim/indentline.vim
  source ~/dotfiles/nvim/vim-yaml-folds.vim
  source ~/dotfiles/nvim/vim-clang-format.vim
  source ~/dotfiles/nvim/vim-cpp-modern.vim

  source ~/dotfiles/nvim/vimtest.vim
call plug#end()


