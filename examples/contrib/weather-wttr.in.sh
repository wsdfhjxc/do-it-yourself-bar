#!/bin/bash

# Requirements: curl
# sudo apt install curl

ID=$1
UPDATE_ONCE=$2

SELF_PATH=$(realpath "$0")
COMMAND="'$SELF_PATH' $ID 1"

update_widget() {
    WEATHER=$(curl wttr.in/?format="%t,%20%C")

    LABEL="N/A"
    [[ -n "$WEATHER" ]] && {
        LABEL=${WEATHER/+/} # remove + symbol
    }

    DATA="| A | ${LABEL^^} | Click to refresh | $COMMAND |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"
}

update_widget
[[ "$UPDATE_ONCE" -ne 1 ]] && {
    while true
    do
        update_widget
        sleep 15m
    done
}
