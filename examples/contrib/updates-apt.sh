#!/bin/bash

# Requirements: inotifywait
# sudo apt install inotify-tools

ID=$1

APT_CACHE_FILE="/var/cache/apt/pkgcache.bin"

update_widget() {
    UPDATES=$(apt list -u 2> /dev/null | grep -c "upgradable")

    LABEL="N/A"
    [[ -n "$UPDATES" ]] && {
        LABEL="$UPDATES"
    }

    DATA="| A | APT: $UPDATES | | |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"
}

update_widget
while true
do
    while inotifywait -e attrib "$APT_CACHE_FILE"
    do
        update_widget
    done
    sleep 0.25s
done
