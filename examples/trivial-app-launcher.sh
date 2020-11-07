#!/bin/bash

ID=$1

DATA+="| A | Kate | Launch Kate | kate |"
DATA+="| A | GIMP | Launch GIMP | flatpak run org.gimp.GIMP |"
DATA+="| A | Inkscape | Launch Inkscape | flatpak run org.inkscape.Inkscape |"

qdbus org.kde.plasma.doityourselfbar /id_$ID \
      org.kde.plasma.doityourselfbar.pass "$DATA"
