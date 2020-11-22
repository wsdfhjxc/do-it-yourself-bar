#!/bin/bash

# Note: This example widget uses Line Awesome font's Unicode glyphs as labels.
# You can find the fa-solid-900.ttf file at https://github.com/icons8/line-awesome
# and put it into ~/.fonts or ~/.local/share/fonts to have it installed.
# Also, to refresh the font cache run: latte-dock --replace & disown

ID=$1
VIEW=$2
SELF_PATH=$(realpath "$0")

case $VIEW in
    VOLUME_VIEW)
        COMMAND_1="qdbus org.kde.kglobalaccel /component/kmix invokeShortcut increase_volume"
        COMMAND_2="qdbus org.kde.kglobalaccel /component/kmix invokeShortcut decrease_volume"
        COMMAND_3="'$SELF_PATH' $ID"

        DATA+="| B |  | Increase volume level | $COMMAND_1 |"
        DATA+="| B |  | Decrease volume level | $COMMAND_2 |"
        DATA+="| C |  | Go back | $COMMAND_3 |"

        ;;

    BRIGHTNESS_VIEW)
        COMMAND_1="qdbus org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut 'Increase Screen Brightness'"
        COMMAND_2="qdbus org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut 'Decrease Screen Brightness'"
        COMMAND_3="'$SELF_PATH' $ID"

        DATA+="| B |  | Increase brightness level | $COMMAND_1 |"
        DATA+="| B |  | Decrease brightness level | $COMMAND_2 |"
        DATA+="| C |  | Go back | $COMMAND_3 |"

        ;;

    *)
        COMMAND_1="qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"
        COMMAND_2="'$SELF_PATH' $ID VOLUME_VIEW"
        COMMAND_3="'$SELF_PATH' $ID BRIGHTNESS_VIEW"
        COMMAND_4="systemsettings5"

        DATA+="| B |  | Lock the screen | $COMMAND_1 |"
        DATA+="| B |  | Change volume level | $COMMAND_2 |"
        DATA+="| B |  | Change brightness level | $COMMAND_3 |"
        DATA+="| B |  | Open system settings | $COMMAND_4 |"

        ;;
esac

qdbus org.kde.plasma.doityourselfbar /id_$ID \
      org.kde.plasma.doityourselfbar.pass "$DATA"
