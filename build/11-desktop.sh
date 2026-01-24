#!/usr/bin/env bash

set -eoux pipefail

# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh
# shellcheck source=/dev/null
source /ctx/build/font-helpers.sh

echo "::group:: Install Desktop Packages"

# Install niri, greetd & DankMaterialShell
dnf5 install --setopt=install_weak_deps=False -y \
    greetd \
    greetd-selinux \
    niri \
    gnome-keyring \
    xdg-desktop-portal-gnome \
    xwayland-satellite \
    mako \
    waybar \
    swaybg \
    swayidle \
    fuzzel

copr_install_isolated "binarypie/hypercube" regreet
copr_install_isolated "scottames/ghostty" ghostty

install_fonts "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/NerdFontsSymbolsOnly.zip"

# Enable services
systemctl enable greetd

# Create tmpfiles.d for greetd
cat > /usr/lib/tmpfiles.d/greetd.conf << 'EOF'
# Type Path                                           Mode UID    GID   Age Argument
d     /var/lib/greetd                                 0750 greetd greetd - -
L     /var/lib/greetd/.config/systemd/user/xdg-desktop-portal.service - - - - /dev/null
d     /var/lib/greetd/.config                      0755 greetd greetd - -
d     /var/lib/greetd/.config/systemd              0755 greetd greetd - -
d     /var/lib/greetd/.config/systemd/user         0755 greetd greetd - -
EOF

# Create user service integration for niri
mkdir -p /etc/systemd/user/niri.service.wants
ln -s /usr/lib/systemd/user/mako.service /etc/systemd/user/niri.service.wants/mako.service
ln -s /usr/lib/systemd/user/waybar.service /etc/systemd/user/niri.service.wants/waybar.service
ln -s /usr/lib/systemd/user/swaybg.service /etc/systemd/user/niri.service.wants/swaybg.service
ln -s /usr/lib/systemd/user/swayidle.service /etc/systemd/user/niri.service.wants/swayidle.service

echo "::endgroup::"
