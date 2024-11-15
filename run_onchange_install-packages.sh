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
#  - noto-fonts: emojis and icons required for rendering certain text in browsers and applications
#  - noto-fonts-cjk: Chinese, Japanese, and Korean fonts
#  - ttf-hack-nerd: nerdfont for terminal, can display icons
#  - arandr: A simple gui xrandr manager for changing display layout
#  - autorandr: A daemon/tool to save configs for monitors and change based on monitor setup (Useful for laptop when 
#    hotplugging HDMI so the second screen pops up and deletes automatically)
#  - arc-gtk-theme: GTK theme I'm currently using.
#  - libnotify: contains notify-send for sending desktop notifications
#  - notification-daemon: notification server required for libnotify to work
#  - ly: TUI login manager (lightdm kept breaking)
#  - xidlehook: Manages events when system is idle. Used for automatic locking and sleeping
yay -S --needed \
	ranger \
	ffmpegthumbnailer \
  neovim \
  w3m \
  xdg-user-dirs \
  feh \
  picom \
  noto-fonts \
  noto-fonts-cjk \
  ttf-hack-nerd \
  arandr \
  autorandr \
  arc-gtk-theme \
  libnotify \
  notification-daemon \
  ly \
  xidlehook \
  bluetuith \
  hyprland \
  waybar \
  rofi-wayland \
  hyprpaper \
  hyprlock \
  hypridle

# setup ly
systemctl enable ly
