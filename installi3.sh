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

echo "# Installing packages for building things"
# Packages for building things
sudo apt install -y git build-essential autoconf gcc make pkg-config automake autoconf bison flex check libtool python3 python3-pip \
  python3-gi python3-setuptools python3-stdeb dh-python

echo "# Setting python -> Python 3"
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10

echo "# Installing packages for our i3-based desktop"
sudo apt install -y \
  feh gucharmap compton udisks2 udiskie at autorandr pasystray pavucontrol pavumeter lxappearance arandr scrot playerctl policykit-1-gnome fd-find network-manager \
  bmon pulsemixer

# Packages required to build i3-gaps
sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev \
  libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
  libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake meson ninja-build

# Packages required to build i3lock-color
sudo apt install -y \
  libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev \
  libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxcb-xtest0-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

# Packages required to build picom
sudo apt install -y \
  libxcb-damage0 libxcb-damage0-dev libxcb-sync-dev libxcb-sync1 libxcb-present-dev libxcb-present0 \
    libxcb-glx0 libxcb-glx0-dev uthash-dev libev-dev libconfig-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev libdbus-1-dev

# Build i3-gaps
echo "# Building i3-gaps"
pushd .tmp
git clone https://github.com/Airblader/i3.git i3-gaps
pushd i3-gaps
git checkout gaps && git pull
mkdir -p build
meson setup build --prefix=/usr/local
meson compile -C build
sudo meson install -C build
popd
popd

# Non apt installs specifically for i3 destktop environment
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

echo "# Build and install picom"
pushd .tmp
curl -fsSL https://github.com/yshui/picom/archive/refs/tags/v9.1.tar.gz -o ../downloads/picom.tar.gz
tar -xzf ../downloads/picom.tar.gz
pushd picom-9.1
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
popd
popd

if [ $1 == "laptop" ]; then
  echo "# Installing some extra packages because we're on a laptop"
  # Packages for just the laptop
  sudo apt update
  sudo apt install -y \
    tlp tlp-rdw

  git clone https://github.com/d4nj1/TLPUI ./.tmp/TLPUI
  cd ./.tmp/TLPUI
  python3 setup.py --command-packages=stdeb.command bdist_deb
  sudo dpkg -i deb_dist/python3-tlpui_*all.deb  # PPAs for just the laptop
  cd ../..
fi

# TODO: Configuration for udiskie if needed, going to assume it is ok by default these days
# https://computingforgeeks.com/automount-removable-media-on-linux-with-udiskie/

echo "# Installing scripts"
sudo cp -Rf i3de/* /

if [ $1 == "laptop" ]; then
  # restart the acpi daemon, so it picks up the hook we added for the laptop lid
  /etc/init.d/acpid restart
  
  # reload udev rules to pick up the rules we added for hdmi hotplug
  sudo udevadm control --reload-rules
else
  # If we're not on a laptop, remove the lid and hdmi hooks, they'll be borked on a desktop
  sudo rm /etc/udev/rules.d/95-monitors.rules
  sudo rm /etc/acpi/events/laptop-lid
fi
