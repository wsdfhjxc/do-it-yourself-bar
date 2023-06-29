#!/bin/bash

#Michael Topple GM5AUG

ID=$1

while true
do
    [[ $(nmcli -f STATE -t g) == "connected" ]] && {
	ip=$(curl -s ifconfig.me)
	localip=$(ip address | grep 192 | awk '{print $2}')
    } || {
        NET="DISCONNECTED"
    }

    BATT=$(cat /sys/class/power_supply/BAT*/capacity)

    DATA=""
    DATA+="| A | WAN $ip | | |"
    DATA+="| B | IP $localip | | |"
    DATA+="| C | BATT $BATT% | | |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"

    sleep 10s
done
