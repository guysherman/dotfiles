#! /bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap microsoft/git
brew install ccls fzf gnutls koekeishiya/formulae/skhd koekeishiya/formulae/yabai \
  libgcrypt libksba libusb neovim npth nvm pinentry python@3.9 ripgrep stow \
  virtualenvwrapper jenv java maven libpq btop kitty go docker docker-compose \
  the_silver_searcher wget ninja meson cmake

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.profile
source ~/.bashrc

echo "# Install node"
nvm install v16.13.1
nvm alias default v16.13.1
npm install -g npm

echo "# Install yarn"
npm install -g yarn

brew install --cask gpg-utils
brew install --cask 1password
brew install --cask cask
brew install --cask kitty
#brew install --cask git-credential-manager-core
#brew install --cask google-chrome
#brew install --cask postman
brew install --cask todoist
brew install --cask slack



FONTS_DIR=/Library/Fonts
curl -fsSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fira%20Code%20Light%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" -o $FONTS_DIR/FiraCodeLightNerdFontCompleteWindowsCompatible.ttf
curl -fsSL "https://www.fontsquirrel.com/fonts/download/cantarell" -o .tmp/cantarell.zip
curl -fsSL "https://github.com/FortAwesome/Font-Awesome/releases/download/5.15.4/fontawesome-free-5.15.4-desktop.zip" -o .tmp/fontawesome.zip

unzip .tmp/cantarell.zip -d $FONTS_DIR
unzip .tmp/fontawesome.zip -d .tmp/fontawesome
cp .tmp/fontawesome/fontawesome-free-5.15.4-desktop/otfs/*.otf $FONTS_DIR/
rm -rf .tmp/fontawesome

mkdir -p ~/.jenv/versions

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
jenv add /usr/local/Cellar/openjdk/17.0.2
jenv global 17.0

env GOBIN="${HOME}/.config/coc/extensions/coc-go-data/bin" go install github.com/fatih/gomodifytags@latest
env GOBIN="${HOME}/.config/coc/extensions/coc-go-data/bin" go install github.com/cweill/gotests/...@latest
env GOBIN="${HOME}/.config/coc/extensions/coc-go-data/bin" go install github.com/haya14busa/goplay/cmd/goplay@latest
env GOBIN="${HOME}/.config/coc/extensions/coc-go-data/bin" go install github.com/josharian/impl@latest
env GOBIN="${HOME}/.config/coc/extensions/coc-go-data/bin" go install golang.org/x/tools/gopls@latest

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

stow mac
stow profile

sudo cp -Rf mac/private/* /private/
brew services start yabai
brew services start skhd
