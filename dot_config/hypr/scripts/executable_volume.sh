#!/bin/bash

# Get current volume and mute status
get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED
}

send_notification() {
    volume=$(get_volume)

    if is_muted; then
        dunstify -a "Volume" -u low -r 9993 -h int:value:0 -i audio-volume-muted "Volume: Muted"
    else
        # Choose icon based on volume level
        if [ "$volume" -eq 0 ]; then
            icon="audio-volume-muted"
        elif [ "$volume" -lt 33 ]; then
            icon="audio-volume-low"
        elif [ "$volume" -lt 67 ]; then
            icon="audio-volume-medium"
        else
            icon="audio-volume-high"
        fi

        dunstify -a "Volume" -u low -r 9993 -h int:value:"$volume" -i "$icon" "Volume: ${volume}%"
    fi
}

case $1 in
    up)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        send_notification
        ;;
    down)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        send_notification
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        send_notification
        ;;
esac
