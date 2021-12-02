" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data').'/plugged')
  source ~/dotfiles/nvim/plugins/nerdtree.vim
  source ~/dotfiles/nvim/plugins/nerdcommenter.vim
  source ~/dotfiles/nvim/plugins/vimspector.vim
  source ~/dotfiles/nvim/plugins/coc.vim
  source ~/dotfiles/nvim/plugins/auto-pairs.vim
  source ~/dotfiles/nvim/plugins/vim-js.vim
  source ~/dotfiles/nvim/plugins/yats.vim
  source ~/dotfiles/nvim/plugins/vim-jsx-pretty.vim
  source ~/dotfiles/nvim/plugins/fzf.vim.vim
  source ~/dotfiles/nvim/plugins/grep.vim
  source ~/dotfiles/nvim/plugins/vimfugitive.vim
  source ~/dotfiles/nvim/plugins/vim-terraform.vim
  source ~/dotfiles/nvim/plugins/lightline.vim
  source ~/dotfiles/nvim/plugins/vim-bbye.vim
  source ~/dotfiles/nvim/plugins/vim-surround.vim
  source ~/dotfiles/nvim/plugins/vim-kitty-navigator.vim
  source ~/dotfiles/nvim/plugins/vim-gh-line.vim
  source ~/dotfiles/nvim/plugins/indentline.vim
  source ~/dotfiles/nvim/plugins/vim-yaml-folds.vim
  source ~/dotfiles/nvim/plugins/vim-clang-format.vim
  source ~/dotfiles/nvim/plugins/vim-cpp-modern.vim
  source ~/dotfiles/nvim/plugins/vimtest.vim
  source ~/dotfiles/nvim/plugins/harpoon.vim
  source ~/dotfiles/nvim/plugins/vim-rooter.vim
call plug#end()


