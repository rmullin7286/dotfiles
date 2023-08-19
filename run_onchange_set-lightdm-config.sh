#!/usr/bin/env sh

# Sets configuration settings for lightdm in /etc/lightdm

# Set the greeter theme for lightdm
# From https://github.com/manilarome/lightdm-webkit2-theme-glorious
# According to the readme, debug_mode is necessary because race conditions sometimes occur with the theme.
sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = glorious #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo sed -i 's/^debug_mode\s*=\s*\(.*\)/debug_mode = true #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
