#!/usr/bin/env sh

# Installs necessary packages shared between systems
#
# The following packages will be installed:
#  - ranger: A terminal file browser used as the default file explorer
#    for the system
#
#  - ffmpegthumbnailer: Used by ranger to display thumbnail previews of
#    videos
#
yay -S --needed \
	ranger \
	ffmpegthumbnailer
