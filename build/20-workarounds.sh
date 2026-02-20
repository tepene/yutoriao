#!/usr/bin/env bash

set -eoux pipefail

echo "::group:: Implement Workarounds"

# Remove fuzzel default config, we have a custom one at /usr/share/yutoriao/etc/xdg/fuzzel
rm -rf /etc/xdg/fuzzel

# Remove waybar default config, we have a custom one at /usr/share/yutoriao/etc/xdg/waybar
# XDG_CONFIG_DIRS not supported -> https://github.com/Alexays/Waybar/wiki/Configuration#config-file
rm -rf /etc/xdg/waybar
ln -sf /usr/share/yutoriao/etc/xdg/waybar /etc/xdg/waybar

# Link custom scripts to /usr/bin/ since setting PATH via /usr/lib/environment.d/ is not working
find /usr/share/yutoriao/bin -maxdepth 1 -type f -exec ln -sf {} /usr/bin/ \;

echo "::endgroup::"
