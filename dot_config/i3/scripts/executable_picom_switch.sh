#!/usr/bin/env sh

# Toggles whether or not the picom compositor is running. Sometimes Picom can
# mess with certain applications and cause slowdown, so you can bind this
# to a hotkey in i3 (I use mod + p) to toggle it off temporarily
if pgrep picom; then

