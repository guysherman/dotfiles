sudo apt install -y \
  libxcb-damage0 libxcb-damage0-dev libxcb-sync-dev libxcb-sync1 libxcb-present-dev libxcb-present0 \
    libxcb-glx0 libxcb-glx0-dev uthash-dev libev-dev libconfig-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev libdbus-1-dev

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
