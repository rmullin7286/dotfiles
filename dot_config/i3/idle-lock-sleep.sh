#!/usr/bin/env sh

xidlehook \
  --not-when-fullscreen \
  --not-when-audio \
  --timer 60 \
    'xrandr --listactivemonitors | awk "NR>1 {print $4}" | xargs -I {} xrandr --output {} --brightness .1' \
    'xrandr --listactivemonitors | awk "NR>1 {print $4}" | xargs -I {} xrandr --output {} --brightness 1' \
  --timer 10 \
    'xrandr --listactivemonitors | awk "NR>1 {print $4} | xargs -I {} xrandr --output {} --brightness 1; i3lock' \
    ''
  --timer 1800 \
    'systemctl hibernate' \
    ''
