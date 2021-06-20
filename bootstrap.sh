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
  echo "include $HOME/dotfiles/kitty/kitty.conf" | sudo tee /etc/xdg/kitty/kitty.conf

  touch .tmp/stage-zero
  echo "Once Oh-My-Zsh has installed, please run the script again now that we're in zsh"

  echo "# Install oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -f .tmp/stage-one ]
then
  echo "# Install user themes extension"
  curl -fsSL "https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com.v42.shell-extension.zip" -o .tmp/userthemes.zip
  extnUuid=`unzip -c .tmp/userthemes.zip metadata.json | grep uuid | cut -d \" -f4`
  mkdir -p ~/.local/share/gnome-shell/extensions/$extnUuid
  unzip -q .tmp/userthemes.zip -d ~/.local/share/gnome-shell/extensions/$extnUuid/
  sudo cp $HOME/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/schemas/org.gnome.shell.extensions.user-theme.gschema.xml /usr/share/glib-2.0/schemas && sudo glib-compile-schemas /usr/share/glib-2.0/schemas
  touch .tmp/stage-one

  echo "Please logout and log back in, then run this script again."
  exit 0
fi
  
if [ ! -f .tmp/stage-two ]
then
  extnUuid=`unzip -c .tmp/userthemes.zip metadata.json | grep uuid | cut -d \" -f4`
  gnome-shell-extension-tool -e $extnUuid
  mkdir -p ~/.local/share/fonts
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fira%20Code%20Light%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" -o ~/.local/share/fonts/FiraCodeLightNerdFontCompleteWindowsCompatible.ttf
  curl -fsSL "https://www.fontsquirrel.com/fonts/download/cantarell" -o .tmp/cantarell.zip
  unzip .tmp/cantarell.zip -d ~/.local/share/fonts
  fc-cache -f -v
  
  echo "# Install the color theme"
  mkdir -p ~/.themes
  tar -C ~/.themes --strip-components=1 -xJvf downloads/plata.tar.xz plata-theme-colors-0.9.1/Plata-Purple-Noir-Compact
  
  echo "# Install the Xenilism minimalism shell theme"
  bash <(wget -qO- https://raw.githubusercontent.com/xenlism/minimalism/master/INSTALL/online.install)
  
  echo "# Set the various UI settings"
  gsettings set org.gnome.shell.extensions.user-theme name "Plata-Purple-Noir-Compact"
  gsettings set org.gnome.desktop.interface gtk-theme "Plata-Purple-Noir-Compact"
  gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle"
  gsettings set org.gnome.desktop.background picture-uri "file://`pwd`/wallpapers/pastel_mountains_v02_color_01_5120x2880.png"
  gsettings set org.gnome.desktop.background picture-options "zoom"
  gsettings set org.gnome.desktop.screensaver picture-uri "file://`pwd`/wallpapers/pastel_mountains_v02_color_01_5120x2880.png"
  gsettings set org.gnome.desktop.screensaver picture-options "zoom"
  gsettings set org.gnome.desktop.interface font-name "Cantarell Medium 9"
  gsettings set org.gnome.desktop.interface document-font-name "Cantarell Medium 9"
  gsettings set org.gnome.desktop.interface monospace-font-name "Monospace 9"
  gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"

  echo "# Install Edge"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
  sudo rm microsoft.gpg

  sudo apt update
  sudo apt install -y microsoft-edge-beta

  echo "# Install Zoom"
  sudo snap install zoom-client

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
  if [ -f ~/.profile ]
  then
    mv ~/.profile ~/.profile.old
  fi
  ln -s `pwd`/.profile `echo ~`/.profile

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
  chmod +x ~/.local/bin/docker-compose
  
  sudo gpasswd -a $USER docker

  echo "# Install various terraforms"
  echo "# 1.0.0 -> terraform"
  curl -fsSL "https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip" -o .tmp/terraform_1.zip
  unzip -p .tmp/terraform_1.zip > ~/.local/bin/terraform
  chmod +x ~/.local/bin/terraform
  
  echo "# 0.14.11 -> terraform014"
  curl -fsSL "https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_linux_amd64.zip" -o .tmp/terraform_014.zip
  unzip -p .tmp/terraform_014.zip > ~/.local/bin/terraform014
  chmod +x ~/.local/bin/terraform014
  
  echo "# Install kubectl"
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt update
  sudo apt install -y kubectl

  echo "# Install nvm"
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  source ~/.profile

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  
  echo "# Install node"
  nvm install --lts
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
  sudo pip install virtualenv virtualenvwrapper
  
  echo "# Setup nvim"
  mkdir -p ~/.config/nvim
  ln -s `pwd`/nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json
  echo "source ~/dotfiles/nvim/init.vim" > ~/.config/nvim/init.vim
  nvim +:PlugInstall +:qa!
  nvim +:CocInstall +:qa!

  gsettings set org.gnome.shell favorite-apps "['microsoft-edge-beta.desktop', \
    'kitty.desktop', 'slack_slack.desktop', 'zoom-client_zoom-client.desktop', \
    'todoist_todoist.desktop', 'org.gnome.Nautilis.desktop', 'nvim.desktop']"

  gsettings set org.gnome.desktop.default-applications.terminal exec kitty
  gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''

  
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



  ln -s `pwd`/.bash_logout `echo ~`/.bash_logout
  ln -s `pwd`/.bashrc `echo ~`/.bashrc
  ln -s `pwd`/.zshrc `echo ~`/.zshrc
  ln -s `pwd`/.dir_colors `echo ~`/.dir_colors

  touch .tmp/stage-three
  echo "Done, please reboot, and then you should be good to go!"
  exit 0
fi

echo "Everything is set up, nothing to do."
