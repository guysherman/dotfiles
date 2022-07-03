#! /usr/bin/env bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Please pass either <latop> or <desktop> (without the angles) as a parameter"
  exit
fi

mkdir -p .tmp
echo "# Install some basic tools we need to install the rest"
sudo apt update
sudo apt install -y wget curl ca-certificates apt-transport-https gnupg lsb-release

# PPAs for both computers
echo "# Add github gpg key"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

echo "# Add neovim PPA"
sudo add-apt-repository -y ppa:neovim-ppa/unstable

echo "# Add 1password PPA"
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

echo "# Add the docker PPA"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "# Add kubernetes PPA"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#echo "# Add edge PPA"
#curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
#sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
#sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list'
#sudo rm microsoft.gpg

#echo "# Add virtualbox PPA"
#curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > virtualbox.gpg
#sudo install -o root -g root -m 644 virtualbox.gpg /etc/apt/trusted.gpg.d/
#echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian hirsute contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
#sudo rm virtualbox.gpg

echo "# Add chromium PPA"
sudo add-apt-repository ppa:phd/chromium-browser

echo "# Add the brave PPA"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
echo "# Install packages via apt"

sudo apt update
# Packages for building things
sudo apt install -y git build-essential autoconf automake make pkg-config gcc bison flex check libtool python3 python3-pip maven

# Packages for both machines, no matter what DE
sudo apt install -y \
  gnome-session gnome-terminal gnome-tweaks \
  1password imagemagick chromium-browser brave-browser \
  stow zsh neovim silversearcher-ag ripgrep gh fzf ruby \
  docker-ce docker-ce-cli containerd.io kubectl \
  libimobiledevice-dev libssl-dev  \
  libusb-dev libusb-1.0-0-dev libplist-dev libplist++-dev usbmuxd markdown xdotool \
  atool mediainfo libncurses-dev build-essential cmake ninja-build libclang-13-dev libclang-common-13-dev \
  libclang-cpp13 libclang1-13 openjdk-11-jdk openjdk-17-jdk meson

# Packages for just the desktop

# Build and install cfiles
echo "# Install cfiles"
pushd .tmp
curl -fsSL https://github.com/mananapr/cfiles/archive/refs/tags/v1.8.tar.gz -o ../downloads/cfiles.tar.gz
tar -xzf ../downloads/cfiles.tar.gz
pushd cfiles-1.8
make
sudo make install
popd
popd

# Non apt installs
echo "# Install gcmcore"
curl -fsSL https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.696/gcmcore-linux_amd64.2.0.696.deb -o ./downloads/gcmcore-linux_amd64.2.0.696.deb
pushd downloads
sudo dpkg -i gcmcore-linux_amd64.2.0.696.deb
popd


echo "# Install Roam"
curl -fsSL https://roam-electron-deploy.s3.us-east-2.amazonaws.com/roam-research_0.0.14_amd64.deb -o downloads/roam-research_0.0.14_amd64.deb
pushd downloads
sudo dpkg -i roam-research_0.0.14_amd64.deb
popd


echo "# Setting python -> Python 3"
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10

echo "# Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "# Install Zoom"
sudo snap install zoom-client
sudo snap connect zoom-client:screencast-legacy

echo "# Install slack"
sudo snap install slack --classic

echo "# Install todoist"
sudo snap install todoist

echo "# Install Chromium"
sudo snap install chromium

echo "# Install postman"
sudo snap install postman

echo "# Install btop"
sudo snap install btop
sudo snap connect btop:home
sudo snap connect btop:system-observe
sudo snap connect btop:mount-observe
sudo snap connect btop:hardware-observe
sudo snap connect btop:network-observe
sudo snap connect btop:process-control
sudo snap connect btop:removable-media

echo "# Setup scripts"
stow scripts

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


echo "Install AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o ".tmp/awscliv2.zip"
unzip -q .tmp/awscliv2.zip -d .tmp
pushd .tmp
sudo ./aws/install
popd

echo "# Install nvm"
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.profile
source ~/.bashrc

echo "# Install node"
nvm install 16 --lts
nvm install-latest-npm

echo "# Install yarn"
npm install -g yarn

echo "# Install virtualenv"
mkdir -p ~/.virtualenvs
sudo pip install virtualenv virtualenvwrapper ueberzug

echo "# Install go"
curl -fsSL https://go.dev/dl/go1.18.1.linux-amd64.tar.gz -o ./downloads/go.tar.gz
sudo tar -C /opt -xzf ./downloads/go.tar.gz

echo "# Install jEnv"
git clone https://github.com/jenv/jenv.git ~/.jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
jenv add /usr/lib/jvm/java-11-openjdk-amd64
jenv add /usr/lib/jvm/java-17-openjdk-amd64

echo "# Install dbeaver"
curl -fsSL https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -o downloads/dbeaver-ce_latest_amd64.deb
pushd downloads
sudo dpkg -i dbeaver-ce_latest_amd64.deb
popd

echo "# Configure GCM core"
git-credential-manager-core configure
git config --global credential.credentialStore secretservice

echo "# Setup kitty"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
pushd ~/.local/bin
ln -s ~/.local/kitty.app/bin/kitty ./kitty
popd
stow kitty

echo "# Setup nvim"
stow nvim-2


echo "# Setup profile"
rm ~/.bash_logout
rm ~/.bashrc
rm ~/.gitconfig
rm ~/.profile
rm ~/.zshrc
stow profile
stow linux

if [ $1 == "laptop" ]; then
  stow laptop
else
  stow desktop
fi
