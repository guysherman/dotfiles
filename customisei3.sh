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

echo "# Install packages via apt"
sudo apt update
# Polybar
sudo apt install -y numix-icon-theme-circle stow 

if [ $1 == "laptop" ]; then
  # Packages for just the laptop
  sudo apt install -y pulseeffects 
fi

# Packages for building things
sudo apt install -y git build-essential autoconf automake make pkg-config gcc bison flex check libtool python3 python3-pip \


# Packages required to build rofi
GDK_PIXBUF_PKG_NAME="libgdk-pixbuf-2.0-dev"
if [ $1 == "desktop" ]; then
  GDK_PIXBUF_PKG_NAME="libgdk-pixbuf2.0-dev"
fi

sudo apt install -y \
  libxml2-utils libxcb-ewmh-dev libxcb-ewmh2 libxcb-cursor-dev  libxcb-icccm4 libxcb-icccm4-dev \
  libpango-1.0-0 libpango1.0-dev libpangocairo-1.0-0 libstartup-notification0-dev $GDK_PIXBUF_PKG_NAME

# Packages to build polybar
sudo apt install -y libpulse-dev libjsoncpp-dev python3-xcbgen xcb-proto \
  libuv1 libuv1-dev python3-sphinx python3-packaging

# Build Polybar
pushd .tmp
git clone --recursive https://github.com/polybar/polybar
pushd polybar
mkdir -p build
pushd build
cmake ..
make -j$(nproc)
sudo make install
popd
popd
popd


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

#if [ $1 == "desktop" ]; then
  #echo "# Install check from source because Ubuntu 20.04 is so old"
  #curl -fsSL https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz -o downloads/check.tar.gz
  #pushd .tmp
  #tar -xzvf ../downloads/check.tar.gz
  #pushd check-0.15.2
  #./configure
  #make
  #sudo make install
  #popd
  #popd
#fi

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
git checkout 1.7.0
./setup.sh
popd
popd

#if [ $1 == "desktop" ]; then
  #sudo apt install -y build-essential git cmake cmake-data pkg-config \
    #python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev \
    #libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev \
    #python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev \
    #libxcb-icccm4-dev

  #sudo apt install -y libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev \
    #libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev \
    #libcurl4-openssl-dev libnl-genl-3-dev

  #curl -fsSL https://github.com/polybar/polybar/releases/download/3.5.7/polybar-3.5.7.tar.gz -o downloads/polybar.tar.gz
  #pushd .tmp
  #tar -xzf ../downloads/polybar.tar.gz
  #pushd polybar-3.5.7
  #mkdir -p build
  #pushd build
  #cmake ..
  #make -j$(nproc)
  #sudo make install
  #popd
  #popd
  #popd
#fi

echo "# Setup i3"
rm -rf ~/.config/rofi/applets/applets/powermenu.sh
rm -rf ~/.config/rofi/applets/styles/colors.rasi
rm -rf ~/.config/rofi/launchers/ribbon/launcher.sh
rm -rf ~/.config/rofi/launchers/ribbon/styles/colors.rasi
rm -rf ~/.config/i3/config
rm -rf ~/.config/gtk-3.0/bookmarks
stow i3

if [ $1 == "laptop" ]; then
  stow laptop-i3
fi

