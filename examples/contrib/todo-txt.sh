#!/bin/bash

# Requirements: inotifywait
# sudo apt install inotify-tools

ID=$1

TODO_TXT_FILE="$HOME/Todo.txt" # change this

update_widget() {
    TODOS=$(grep -c -v -Po "^(x |\s?$)" "$TODO_TXT_FILE")

    LABEL="N/A"
    [[ -n "$TODOS" ]] && {
        LABEL="$TODOS"
    }

    DATA="| A | TODO: $TODOS | | |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"
}

update_widget
while true
do
    while inotifywait -e modify "$TODO_TXT_FILE"
    do
        update_widget
    done
    sleep 0.25s
done
