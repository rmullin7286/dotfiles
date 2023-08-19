#!/usr/bin/env sh

# Installs necessary packages shared between systems
#
# The following packages will be installed:
#  - ranger: A terminal file browser used as the default file explorer
#    for the system
#  - ffmpegthumbnailer: Used by ranger to display thumbnail previews of
#    videos
#  - neovim: Default text editor, use instead of vim
#  - w3m: Used mainly for displaying images in the terminal in ranger
#  - xdg-user-dirs: Used to create default user directories like Documents, Downloads, Pictures, etc.
#  - feh: Image viewing software, also used to change desktop background
#  - picom: Compositor for i3wm
#  - light: Backlight control tool. This project is technically orphaned. If it ever breaks I'll just 
#    write one myself, it's not that hard.
#  - noto-fonts-emoji: emojis and icons required for rendering certain text in browsers and applications
#  - lightdm-webkit2-theme-glorious: better theme for lightdm webkit2 greeter
yay -S --needed \
	ranger \
	ffmpegthumbnailer \
  neovim \
  w3m \
  xdg-user-dirs \
  feh \
  picom \
  light \
  noto-fonts-emoji \
  lightdm-webkit2-theme-glorious
