#!/bin/bash

$(echo $WEATHER | sed "s/\+//g")# Requirements: playerctl
# sudo apt install playerctl

ID=$1
UPDATE_ONCE=$2

SELF_PATH=$(realpath "$0")

update_widget() {
    STATUS="$(playerctl status)"

    LABEL="N/A"
    TOOLTIP="Not playing anything"

    [[ "$STATUS" == "Playing" ]] || [[ "$STATUS" == "Paused" ]] && {
        MEDIA_TITLE=$(playerctl metadata title)
        LABEL="${MEDIA_TITLE^^}"
        TOOLTIP="Click to play/pause"
        COMMAND="playerctl play-pause; '$SELF_PATH' $ID 1"
    }
    [[ "$STATUS" == "Paused" ]] && {
        LABEL="PAUSED: $LABEL"
    }

    LABEL=${LABEL//|/\\|} # escape possible | separators

    DATA="| A | $LABEL | $TOOLTIP | $COMMAND |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"
}

update_widget
[[ "$UPDATE_ONCE" -ne 1 ]] && {
    while true
    do
        sleep 5s
        update_widget
    done
}
