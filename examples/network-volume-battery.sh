#!/bin/bash

ID=$1

while true
do
    NET=$(nmcli -f STATE -t g)
    VOL=$(amixer -D pulse sget Master | grep -Po "\[\K(\d+)" | head -n 1)
    BATT=$(cat /sys/class/power_supply/BAT*/capacity)

    DATA=""
    DATA+="| A | ${NET^^} | | |"
    DATA+="| B | VOL $VOL% | | |"
    DATA+="| C | BATT $BATT% | | |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"

    sleep 10s
done
