#!/bin/bash

# Requirements: KDE Connect

ID=$1

DEVICE_ID="XXXXXXXXXXXXXXXX" # change this
QUERY_COMMAND="qdbus org.kde.kdeconnect \
/modules/kdeconnect/devices/$DEVICE_ID \
org.kde.kdeconnect.device.battery.charge"

while true
do
    BATTERY_LEVEL=$($QUERY_COMMAND)

    STYLE="A"
    TOOLTIP="I'm fine, thanks..."
    [[ "$BATTERY_LEVEL" -le 15 ]] && {
        STYLE="C"
        TOOLTIP="Hey! Plug me in!"
    }

    BATTERY_LEVEL_PERCENT="N/A"
    [[ -n "$BATTERY_LEVEL" ]] && {
        BATTERY_LEVEL_PERCENT="$BATTERY_LEVEL%"
    }

    DATA="| $STYLE | PHONE: $BATTERY_LEVEL_PERCENT | $TOOLTIP | |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"

    sleep 30s
done
