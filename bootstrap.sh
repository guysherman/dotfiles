#! /bin/bash

set -euo pipefail

mkdir -p .tmp
if [ ! -f .tmp/stage-zero ]
then

  echo "# Install some basic tools we need to install the rest"
  sudo apt update
  sudo apt install -y wget curl ca-certificates apt-transport-https gnupg lsb-release
  
  echo "# Install some basics"
  sudo apt update
  sudo apt install -y gnome-session gnome-terminal \
    gnome-tweaks zsh kitty \
    python3 python3-pip neovim numix-icon-theme-circle build-essential git

  echo "# Apply kitty config"
  echo "include /home/guy/dotfiles/kitty/kitty.conf" | sudo tee /etc/xdg/kitty/kitty.conf

  echo "# Install oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  touch .tmp/stage-zero
  echo "please run the script again now that we're in zsh"
fi

if [! -f .tmp/stage-one ]
then
  echo "# Install user themes extension"
  curl -L "https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com.v42.shell-extension.zip" -o .tmp/userthemes.zip
  extnUuid = `unzip -c .tmp/userthemes.zip metadata.json | grep uuid | cut -d \" -f4`
  mkdir -p ~/.local/share/gnome-shell/extensions/$extnUuid
  unzip -q .tmp/userthemes.zip -d ~/.local/share/gnome-shell/extensions/$extnUuid/
  touch .tmp/stage-one

  echo "Please logout and log back in, then run this script again."
  exit 0
fi
  
if [ ! -f .tmp/stage-two ]
then
  extnUuid = `unzip -c .tmp/userthemes.zip metadata.json | grep uuid | cut -d \" -f4`
  gnome-shell-extension-tool -e $extnUuid
  mkdir -p ~/.local/share/fonts
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fira%20Code%20Light%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" -o ~/.local/share/fonts/FiraCodeLightNerdFontCompleteWindowsCompatible.ttf
  fc-cache -f -v
  
  echo "# Install the color theme"
  mkdir -p ~/.themes
  curl -fsSL "https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE1NzYwNTQ3NTEiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjAyYmI1YTVhMTk3ZGNjYTNmNmE0NmUzMjZlMDMwMDUyZWVkOTJjNGNmODI5Y2ZlMzYzODU0ZWE3ZjAxNjcxZTYxYzg5YmQ2OGZjOTZlNjdkYzA0NGNhOWFjNDYyYjc5MWIzYWViMmM2MTM0NzhjYjBmMzgzMDgxMjIwN2Y2YzNlIiwidCI6MTYyNDA5NTEyMiwic3RmcCI6IjliZjAyZjExNmQwOTBlNDg3ZTJiYjU0ZmFlYjUwMDU5Iiwic3RpcCI6IjE1OC4xNDAuMjM1LjE5MCJ9.x2_mHSItzdaoiAEgMLXqvpm2f53HvNUVNITFckZ53qU/plata-theme-colors-0.9.1.tar.xz" -o .tmp/plata.tar.xz
  tar -C ~/.themes --strip-components=1 -xJvf plata.tar.xz plata-theme-colors-0.9.1/Plata-Purple-Noir-Compact
  
  echo "# Install the Xenilism minimalism shell theme"
  bash <(wget -qO- https://raw.githubusercontent.com/xenlism/minimalism/master/INSTALL/online.install)
  
  echo "# Set the various UI settings"
  gsettings set org.gnome.shell.extensions.user-theme name "Xenlism-Minimalism"
  gsettings set org.gnome.desktop.interface gtk-theme "Plata-Purple-Noir-Compact"
  gsettings set org.gnome.dekstop.interface icon-theme "Numix-Circle"
  gsettings set org.gnome.dekstop.background picture-uri "file://`pwd`/wallpapers/pastel_mountains_v02_color_01_5120x2880.png"
  gsettings set org.gnome.desktop.background pcicture-options "wallpaper"
  gsettings set org.gnome.dekstop.screensaver picture-uri "file://`pwd`/wallpapers/pastel_mountains_v02_color_01_5120x2880.png"
  gsettings set org.gnome.desktop.screensaver pcicture-options "wallpaper"

  echo "# Install Edge"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
  sudo rm microsoft.gpg

  sudo apt update
  sudo apt install -y microsoft-edge-beta

  echo "# Install Zoom"
  curl -fsSL "https://cdn.zoom.us/prod/5.6.22045.0607/zoom_amd64.deb" -o .tmp/zoom.deb
  sudo apt install -y .tmp/zoom.deb

  echo "# Install slack"
  sudo snap install slack --classic


  echo "# Install todoist"
  sudo snap install todoist

  touch .tmp/stage-two
  echo "Please logout and log back in, then run this script one last time."
  exit 0
fi  

if [ ! -f .tmp/stage-three ]
then
  echo "# Add the docker apt repo and install docker"
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  
  echo "# Install docker-compose"
  mkdir -p ~/.local/bin
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64" -o ~/.local/bin/docker-compose
  
  echo "# Install various terraforms"
  echo "# 1.0.0 -> terraform"
  curl -fsSL "https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip" -o .tmp/terraform_1.zip
  unzip .tmp/terraform_1.zip -p > ~/.local/bin/terraform
  
  echo "# 0.14.11 -> terraform014"
  curl -fsSL "https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_linux_amd64.zip" -o .tmp/terraform_014.zip
  unzip .tmp/terraform_014.zip -p > ~/.local/bin/terraform014
  
  echo "# Install nvm"
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  source ~/.profile
  
  echo "# Install node"
  nvm install lts
  nvm install-latest-npm
  
  echo "# Install yarn"
  npm install -g yarn
  
  echo "# Install sqlworkbench/j"
  sudo apt install -y openjdk-16-jre
  curl -fsSL "https://www.sql-workbench.eu/Workbench-Build127-with-optional-libs.zip" -o .tmp/sqlworkbench.zip
  mkdir -p ~/.local/opt/sqlworkbench
  unzip -q .tmp/sqlworkbench.zip -d ~/.local/opt/sqlworkbench
  mkdir -p ~/.local/opt/jdbc
  curl -fsSL "https://jdbc.postgresql.org/download/postgresql-42.2.22.jar" -o ~/.local/opt/jdbc/postgresql.jar
  
  echo "# Install virtualenv"
  mkdir -p ~/.virtualenvs
  pip install virtualenv virtualenvwrapper
  
  echo "# Setup nvim"
  nvim +:PlugInstall +:CocInstall +:qa!
  
  echo "# Map over our bash/zsh files"
  
  if [ -f ~/.bash_logout ]
  then
    mv ~/.bash_logout ~/.bash_logout.old
  fi
    
  if [ -f ~/.bashrc ]
  then
    mv ~/.bashrc ~/.bashrc.old
  fi
  
  
  if [ -f ~/.zshrc ]
  then
    mv ~/.zshrc ~/.zshrc.old
  fi

  if [ -f ~/.dir_colors ]
  then
    mv ~/.dir_colors ~/.dir_colors.old
  fi

  if [ -f ~/.profile ]
  then
    mv ~/.profile ~/.profile.old
  fi


  ln -s `pwd`/.bash_logout `echo ~`/.bash_logout
  ln -s `pwd`/.bashrc `echo ~`/.bashrc
  ln -s `pwd`/.zshrc `echo ~`/.zshrc
  ln -s `pwd`/.dir_colors `echo ~`/.dir_colors
  ln -s `pwd`/.profile `echo ~`/.profile

  touch .tmp/stage-three
  echo "We're done, please log out and log back in again."
  exit 0
fi

echo "Everything is set up, nothing to do."
