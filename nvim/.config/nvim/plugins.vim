" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data').'/plugged')
  source ~/dotfiles/nvim/.config/nvim/plugins/lua.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/nerdtree.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/nerdcommenter.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vimspector.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/coc.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/auto-pairs.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-js.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/yats.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-jsx-pretty.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/telescope.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/git-worktree.vim
"  source ~/dotfiles/nvim/.config/nvim/plugins/fzf.vim.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/grep.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vimfugitive.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-terraform.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/lightline.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-bbye.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-surround.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-kitty-navigator.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-gh-line.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/indentline.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-yaml-folds.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-clang-format.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-cpp-modern.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vimtest.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/harpoon.vim
  source ~/dotfiles/nvim/.config/nvim/plugins/vim-rooter.vim
call plug#end()

doautocmd User PlugLoaded


