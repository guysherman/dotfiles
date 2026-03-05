#! /bin/bash

mkdir -p ./.tmp

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install neovim fzf ripgrep the_silver_searcher stow fnm gpg uv pinentry-mac direnv
brew install --cask kitty


# Oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


FONTS_DIR=/Library/Fonts
curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip" -o .tmp/FiraCode.zip
curl -fsSL "https://font.download/dl/font/cantarell.zip" -o .tmp/cantarell.zip
curl -fsSL "https://github.com/FortAwesome/Font-Awesome/releases/download/7.1.0/fontawesome-free-7.1.0-desktop.zip" -o .tmp/fontawesome.zip

unzip .tmp/FiraCode.zip -d ./.tmp/firacode
cp .tmp/firacode/FireCodeNerdFontMono-*.tmp
rm -rf .tmp/firacode

unzip .tmp/cantarell.zip -d $FONTS_DIR/
unzip .tmp/fontawesome.zip -d .tmp/fontawesome
cp .tmp/fontawesome/fontawesome-free-7.1.0-desktop/otfs/*.otf $FONTS_DIR/
rm -rf .tmp/fontawesome


echo "# Setup kitty"
stow kitty

echo "# Setup nvim"
stow nvim-2

echo "# Setup scripts"
stow scripts

echo "# Setup profile"
rm ~/.bash_logout
rm ~/.bashrc
rm ~/.gitconfig
rm ~/.profile
rm ~/.zshrc
rm ~/.zprofile

stow profile

