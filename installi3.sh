#! /usr/bin/bash

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

echo "# Setting python -> Python 3"
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10

echo "# Installing packages for our i3-based desktop"
sudo apt install -y \
  i3 gucharmap compton udisks2 udiskie at autorandr pasystray pavucontrol pavumeter lxappearance arandr scrot playerctl policykit-1-gnome fd-find network-manager \

# Packages required to build i3lock-color
sudo apt install -y \
  libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev \
  libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxcb-xtest0-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev


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

if [ $1 == "laptop" ]; then
  echo "# Installing some extra packages because we're on a laptop"
  # PPAs for just the laptop
  echo "# Add linuxuprising PPA"
  sudo add-apt-repository -y ppa:linuxuprising/apps
  # Packages for just the laptop
  sudo apt update
  sudo apt install -y \
    tlp tlp-rdw tlpui
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