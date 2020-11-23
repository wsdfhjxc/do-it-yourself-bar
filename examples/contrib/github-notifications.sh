#!/bin/bash

# Requirements: curl, jq
# sudo apt install curl jq

ID=$1
UPDATE_ONCE=$2

USER="XXXXXXXXXXXXXXXX" # change this
TOKEN="XXXXXXXXXXXXXXXXXXXXXXX" # change this
API_URL="https://api.github.com/notifications"

SELF_PATH=$(realpath "$0")
COMMAND="'$SELF_PATH' $ID 1"

update_widget() {
    JSON=$(echo "user = \"$USER:$TOKEN\"" | curl -sf -K- "$API_URL")

    NOTIFICATIONS="N/A"
    [[ -n "$JSON" ]] && {
        NOTIFICATIONS=$(echo "$JSON" | jq ".[].unread" | grep -c true)
    }

    case "$NOTIFICATIONS" in
        "N/A"|0) STYLE="A" ;;
        *) STYLE="C" ;;
    esac

    DATA="| $STYLE | GITHUB: $NOTIFICATIONS | Click to refresh | $COMMAND |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"
}

update_widget
[[ "$UPDATE_ONCE" -ne 1 ]] && {
    while true
    do
        sleep 10m
        update_widget
    done
}
