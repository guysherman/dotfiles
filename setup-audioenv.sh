#! /usr/bin/env bash

set -euo pipefail

mkdir -p .tmp

echo "Stowing audio"
stow audio

echo "# Add KXStudio Repos"
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_11.0.1_all.deb
sudo dpkg -i kxstudio-repos_11.0.1_all.deb
sudo apt update

echo "# Installing audio stuff"
sudo apt install \
  jackd2 libjack-jackd2-0 libjack-jackd2-dev pulseaudio-module-jack carla guitarix-lv2 \
  dpf-plugins-lv2 lsp-plugins-lv2 x42-plugins hydrogen hydrogen-drumkits \
  hydrogen-drumkits-effects zynaddsubfx zyaddsubfx-lv2 a2jmidid surge japa

echo ""
echo "Please download the latest ardour installer to $HOME/dotfiles/downloads/ardour.run"
echo ""
read -n1 -s -r -p $'Once complete, press any key to continue...'
echo ""

chmod +x ./downloads/ardour.run
./downloads/ardour.run

echo ""
echo "Please download the harrison plugins tarball to $HOME/dotfiles/downloads/harrison-plugins.tar.gz"
echo ""
read -n1 -s -r -p $'Once complete, press any key to continue...'
echo ""

sudo mkdir -p /usr/lib/lv2
tar -C /usr/lib/lv2 -xzf ./downloads/Harrison.lv2.tar.gz

echo ""
echo "Please download the harrison and ardour license files tarball to"
echo "$HOME/dotfiles/downloads/audio-licenses.tar.gz"
echo ""
read -n1 -s -r -p $'Once complete, press any key to continue...'
echo ""

tar -C $HOME ./downloads/audio-licenses.tar.gz

echo ""
echo "Please download VCVRack2 to $HOME/dotfiles/downloads/rack2.zip"
echo ""
read -n1 -s -r -p $'Once complete, press any key to continue...'
echo ""

mkdir -p $HOME/.local/share/VCV
mkdir -p $HOME/.vst
unzip ./downloads/rack2.zip -d $HOME/.local/share/VCV
mv $HOME/.local/share/VCV/'VCV Rack 2.so' $HOME/.vst/'VCV Rack 2.so'
mv $HOME/.local/share/VCV/'VCV Rack 2 FX.so' $HOME/.vst/'VCV Rack 2 FX.so'

echo "# Installing tascam util"
mkdir -p ~/source
git clone git@github.com:guysherman/tascam-util ~/source/tascam-util
