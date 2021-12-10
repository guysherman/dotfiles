#! /bin/bash

set -euo pipefail

mkdir -p .tmp
echo "# Install some basic tools we need to install the rest"
sudo apt update
sudo apt install -y wget curl ca-certificates apt-transport-https gnupg lsb-release

echo "# Add github gpg key"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

echo "# Add neovim PPA"
sudo add-apt-repository -y ppa:neovim-ppa/stable
echo "# Add linuxuprising PPA"
sudo add-apt-repository -y ppa:linuxuprising/apps

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

echo "# Add edge PPA"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo rm microsoft.gpg

echo "# Add virtualbox PPA"
curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > virtualbox.gpg
sudo install -o root -g root -m 644 virtualbox.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian hirsute contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo rm virtualbox.gpg

echo "# Install packages via apt"
sudo apt update
sudo apt install -y gnome-session gnome-terminal \
  gnome-tweaks zsh kitty \
  python3 python3-pip \
  neovim numix-icon-theme-circle build-essential \
  git silversearcher-ag libxml2-utils gh autoconf \
  automake libusb-dev libusb-1.0-0-dev libplist-dev \
  libplist++-dev usbmuxd libtool \
  libimobiledevice-dev libssl-dev lxappearance arandr scrot playerctl policykit-1-gnome \
  stow pasystray pavucontrol pavumeter tlp tlp-rdw tlpui gucharmap polybar compton udisks2 udiskie at autorandr \
  autoconf libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev \
  libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev \
  libxcb-util-dev libxcb-xrm-dev libxcb-xtest0-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev \
  fd-find ripgrep libxcb-ewmh-dev libxcb-ewmh2 libxcb-cursor-dev bison flex check libxcb-icccm4 libxcb-icccm4-dev \
  libpango-1.0-0 libpango1.0-dev libpangocairo-1.0-0 libstartup-notification0-dev libgdk-pixbuf-2.0-dev \
  microsoft-edge-beta docker-ce docker-ce-cli containerd.io kubectl 1password i3 virtualbox-6.1 imagemagick pulseeffects fzf

echo "# Install gcmcore"
curl -fsSL https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.567/gcmcore-linux_amd64.2.0.567.18224.deb -o downloads/gcmcore-linux_amd64.2.0.567.18224.deb
pushd downloads
sudo dpkg -i gcmcore-linux_amd64.2.0.567.18224.deb
popd

echo "# Install dbeaver"
curl -fsSL https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -o downloads/dbeaver-ce_latest_amd64.deb
pushd downloads
sudo dpkg -i dbeaver-ce_latest_amd64.deb
popd

echo "# Setting python -> Python 3"
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10

echo "# Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "# Installing fonts"
mkdir -p ~/.local/share/fonts
curl -fsSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fira%20Code%20Light%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" -o ~/.local/share/fonts/FiraCodeLightNerdFontCompleteWindowsCompatible.ttf
curl -fsSL "https://www.fontsquirrel.com/fonts/download/cantarell" -o .tmp/cantarell.zip
curl -fsSL "https://github.com/FortAwesome/Font-Awesome/releases/download/5.15.4/fontawesome-free-5.15.4-desktop.zip" -o .tmp/fontawesome.zip

unzip .tmp/cantarell.zip -d ~/.local/share/fonts
unzip .tmp/fontawesome.zip -d .tmp/fontawesome
cp .tmp/fontawesome/fontawesome-free-5.15.4-desktop/otfs/*.otf ~/.local/share/fonts/
rm -rf .tmp/fontawesome
fc-cache -f -v

echo "# Install the color theme"
mkdir -p ~/.themes
#tar -C ~/.themes --strip-components=1 -xJvf downloads/plata.tar.xz plata-theme-colors-0.9.1/Plata-Purple-Noir-Compact
curl -fsSL "https://github.com/daniruiz/flat-remix-gtk/archive/refs/heads/master.zip" -o downloads/flat-remix-gtk-master.zip
curl -fsSL "https://github.com/daniruiz/flat-remix-gnome/archive/refs/heads/master.zip" -o downloads/flat-remix-gnome-master.zip
unzip -q downloads/flat-remix-gnome-master.zip -d .tmp
cp -R .tmp/flat-remix-gnome-master/themes/Flat-Remix-Blue-Dark-fullPanel ~/.themes/Flat-Remix-Blue-Dark-fullPanel

unzip -q downloads/flat-remix-gtk-master.zip -d .tmp
cp -R .tmp/flat-remix-gtk-master/themes/Flat-Remix-GTK-Blue-Dark-Solid ~/.themes/Flat-Remix-GTK-Blue-Dark-Solid

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
sudo snap connect btop:system-observe
sudo snap connect btop:physical-memory-observe
sudo snap connect btop:mount-observe
sudo snap connect btop:hardware-observe
sudo snap connect btop:network-observe
sudo snap connect btop:process-control

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
source ~/.profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "# Install node"
nvm install 16 --lts
nvm install-latest-npm

echo "# Install yarn"
npm install -g yarn

echo "# Install virtualenv"
mkdir -p ~/.virtualenvs
sudo pip install virtualenv virtualenvwrapper

echo "# Build and install i3lock-color"
pushd .tmp
curl -fsSL https://github.com/Raymo111/i3lock-color/archive/refs/tags/2.13.c.4.tar.gz -o ../downloads/i3lock-color.tgz
tar -xzf ../downloads/i3lock-color.tgz
pushd i3lock-color-2.13.c.4
sudo ./install-i3lock-color.sh
popd
popd

echo "# Build and install betterlockscreen"
pushd .tmp
curl -fsSL https://github.com/betterlockscreen/betterlockscreen/archive/refs/tags/v4.0.3.tar.gz -o ../downloads/betterlockscreen.tar.gz
tar -xzf ../downloads/betterlockscreen.tar.gz
pushd betterlockscreen-4.0.3
sudo cp betterlockscreen /usr/local/bin/betterlockscreen
popd
popd

echo "# Build and install rofi"
pushd .tmp
curl -fsSL https://github.com/davatorium/rofi/releases/download/1.7.2/rofi-1.7.2.tar.gz -o ../downloads/rofi.tar.gz
tar -xzf ../downloads/rofi.tar.gz
pushd rofi-1.7.2
mkdir -p build && cd build
../configure
make
sudo make install
cd ..
popd
popd

echo "# Install rofi themes"
pushd .tmp
git clone https://github.com/adi1090x/rofi.git rofi-themes
pushd rofi-themes
./setup.sh
popd
popd

echo "# Configure GCM core"
git-credential-manager-core configure
git config --global credential.credentialStore secretservice

echo "# Setup kitty"
stow kitty

echo "# Setup nvim"
stow nvim
nvim +:PlugInstall +:qa!
nvim +:CocInstall +:qa!

echo "# Setup scripts"
stow scripts

echo "# Setup profile"
rm ~/.bash_logout
rm ~/.bashrc
rm ~/.gitconfig
rm ~/.profile
rm ~/.zshrc
stow profile

echo "# Setup i3"
rm ~/.config/rofi/applets/applets/powermenu.sh
rm ~/.config/rofi/applets/styles/colors.rasi
rm ~/.config/rofi/launchers/ribbon/launcher.sh
rm ~/.config/rofi/launchers/ribbon/styles/colors.rasi
stow i3
sudo ln -s /home/guy/.local/bin/i3-session.sh /usr/local/bin/i3-session.sh
sudo cp /home/guy/.local/share/xsession/i3-session.desktop /usr/share/xsessions/i3-session.desktop

stow laptop
sudo ln -s /home/guy/.config/acpi/events/laptop-lid /etc/acpi/events/laptop-lid
sudo ln -s /home/guy/.config/udev/95-monitors.rules /etc/udev/rules.d/95-monitors.rules

echo "Everything is set up, nothing to do."
