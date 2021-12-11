#! /bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Please pass either <latop> or <desktop> (without the angles) as a parameter"
  exit
fi

mkdir -p .tmp
echo "# Install some basic tools we need to install the rest"
sudo apt update
sudo apt install -y wget curl ca-certificates apt-transport-https gnupg lsb-release

echo "# Install packages via apt"
sudo apt update
# Polybar
sudo apt install -y polybar numix-icon-theme-circle

if [ $1 == "laptop" ]; then
  # Packages for just the laptop
  sudo apt install -y pulseeffects
fi

# Packages for building things
sudo apt install -y git build-essential autoconf automake make pkg-config gcc bison flex check libtool python3 python3-pip \

# Packages required to build rofi
sudo apt install -y \
  libxml2-utils libxcb-ewmh-dev libxcb-ewmh2 libxcb-cursor-dev  libxcb-icccm4 libxcb-icccm4-dev \
  libpango-1.0-0 libpango1.0-dev libpangocairo-1.0-0 libstartup-notification0-dev libgdk-pixbuf-2.0-dev

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

echo "# Setup i3"
rm ~/.config/rofi/applets/applets/powermenu.sh
rm ~/.config/rofi/applets/styles/colors.rasi
rm ~/.config/rofi/launchers/ribbon/launcher.sh
rm ~/.config/rofi/launchers/ribbon/styles/colors.rasi
stow i3

if [ $1 == "laptop" ]; then
  stow laptop-i3
fi