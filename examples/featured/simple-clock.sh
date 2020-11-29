#!/bin/bash

ID=$1

while true
do
    HOUR_MINUTE=$(date "+%H:%M")
    DAY_MONTH_YEAR=$(date "+%d-%m-%Y")
    COMMAND="plasmawindowed org.kde.plasma.calendar"

    DATA="| A | $HOUR_MINUTE | $DAY_MONTH_YEAR | $COMMAND |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"

    sleep 5s
done
