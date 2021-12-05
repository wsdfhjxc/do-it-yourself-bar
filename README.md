# Do It Yourself Bar

This is an applet for KDE Plasma panel (or Latte Dock) that lets you create simple, interactive, text-based widgets containing dynamically updated information from various sources. Its main feature is the usage of D-Bus for data input, which means that the widgets can be updated anytime on demand, e.g. from Bash scripts, KWin scripts, etc.

In terms of user experience, the plasmoid is similar to [Kargos](https://github.com/lipido/kargos) or [Command Output](https://github.com/Zren/plasma-applet-commandoutput) applets. The data can be presented neatly, but the string formatting and sending it to the applet is on the user. Hence "Do It Yourself" in the title. For more details about available features and for some examples, see the section about configuration and usage.

## Screenshots

Simple clock widget example:

![](screenshots/1.gif)

Trivial app launcher widget example:

![](screenshots/2.gif)

Network/volume/battery widget example:

![](screenshots/3.gif)

Pager-like widget used by a KWin script:

![](screenshots/4.gif)

Interactive quick actions widget example:

![](screenshots/5.gif)

## Installation

To install the applet, you need to build it from source.

First, you need to install some required dependencies:

* On Fedora run: `./scripts/install-dependencies-fedora.sh`
* On openSUSE run: `./scripts/install-dependencies-opensuse.sh`
* On Arch Linux or Manjaro run: `./scripts/install-dependencies-arch.sh`
* On Kubuntu or KDE neon run: `./scripts/install-dependencies-ubuntu.sh`

Then, to compile the source code and install the applet run: `./scripts/install-applet.sh`

Note: This also applies if you want to upgrade to a newer version.

Note: If you want to remove the applet run: `./scripts/uninstall-applet.sh`

After that, you should be able to find Do it Yourself Bar in the Add Widgets menu.

## Configuration and usage

The applet has some options regarding its behavior and visuals. You'll find them in the configuration dialog.

The first thing to do, is to set up the D-Bus service for a given instance of the applet. In the Behavior tab, an unique numeric ID (e.g. 1, 123, 999, etc.) must be assigned, so that it doesn't collide with IDs of other running instances.

You can also set a path for the startup script here. The script will be executed after the applet is loaded, so it should send data to the plasmoid. The instance's ID will be passed to the script as the first argument. Please see the next sections to know what the actual script content should look like, and to take some code as an example.

Other than that, in the Appearance tab, you can also customize the appearance of buttons and labels displayed by the plasmoid. There are some common options, and also there are three style definitions (A, B, C), that can have different colors (with an alpha channel), and which will be applied to given data blocks, depending on the provided string.

### Formatting the data

The applet is able to display multiple data blocks as clickable buttons with labels and tooltips. Each block specification consists of: the style, the label text, the tooltip text, the command to be executed on click. Every part of a block must be separated with the `|` symbol. Each block specification must be started and ended with the `|` symbol as well.

```
| A | Label text | Tooltip text | command_to_execute_on_click |
```

Parts can be omitted, but the `|` separators must be preserved.

```
| A | Label text | | |
```

And here is how multiple buttons can be specified:

```
| A | First button | Tooltip text | command |
| A | Second button, without a tooltip, non-clickable | | |
| B | Third button using style B instead of A | Tooltip text | command |
```

Note: If all parts are omitted, the applet will display nothing.

Note: If the label text is omitted, the applet will display an empty button.

Note: If the separator symbol needs to be a part of the label or the tooltip text, it can be escaped like this: `\|`

Note: Do not include line breaks between buttons.

#### Extra Qt text formatting

If you want to have more control from within the script (e.g. in regard to colors, or mixing different fonts, etc.), you can try formatting the text with Qt's supported HTML subset. See [this page](https://doc.qt.io/qt-5/richtext-html-subset.html) for more details. And here is an example:

```
| A | <font color='#ff0000'>This label will be red</font> | | |
| A | <font face='Hack'>123</font> 456 | | |
```

Note: Remember that HTML tags count towards the label's length (characters).

### Passing the data through D-Bus

Here is an example of using the `qdbus` tool from CLI:

```bash
ID=         # ID of the applet's instance
DATA=       # formatted string containing the data

qdbus org.kde.plasma.doityourselfbar /id_$ID \
      org.kde.plasma.doityourselfbar.pass "$DATA"
```

Here is an example of using the `callDBus` method within a KWin script:

```javascript
var id =    // ID of the applet's instance
var data =  // formatted string containing the data

callDBus("org.kde.plasma.doityourselfbar", "/id_" + id,
         "org.kde.plasma.doityourselfbar", "pass", data);
```

Here is an example of using the `pydbus` library within a Python script:

```python
#!/bin/python3
from pydbus import SessionBus
from sys import argv

if len(argv) == 1:
    print("No DIY bar ID given!")
    quit()

diy=SessionBus().get("org.kde.plasma.doityourselfbar","/id_"+argv[1])
diy=getattr(diy, 'pass') # pass is a keyword so you can't use diy.pass

diy('|A|Label|Tooltip|kdialog --passivepopup "$(date)" 10 --title "Hello World"|')

```

Here is an example of using the `dbus-python` library within a Python script (Only lines 2 and 9 are different from above):

```python
#!/bin/python3
from dbus import SessionBus
from sys import argv

if len(argv) == 1:
    print("No DIY bar ID given!")
    quit()

diy=SessionBus().get_object("org.kde.plasma.doityourselfbar","/id_"+argv[1])
diy=getattr(diy, 'pass') # pass is a keyword so you can't use diy.pass

diy('|A|Label|Tooltip|kdialog --passivepopup "$(date)" 10 --title "Hello World"|')

```

Of course the D-Bus method call should be performed after the plasmoid is loaded (the Plasma's panel or Latte Dock must be already running). But if you only use the startup script, you don't need to worry about that.

### Some actually useful examples

Below you can see Bash scripts implementing the widgets seen on the screenshots.

#### Simple clock widget

```bash
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
```

#### Trivial app launcher widget

```bash
#!/bin/bash

ID=$1

DATA+="| A | Kate | Launch Kate | kate |"
DATA+="| A | GIMP | Launch GIMP | flatpak run org.gimp.GIMP |"
DATA+="| A | Inkscape | Launch Inkscape | flatpak run org.inkscape.Inkscape |"

qdbus org.kde.plasma.doityourselfbar /id_$ID \
      org.kde.plasma.doityourselfbar.pass "$DATA"
```

#### Network/volume/battery widget

```bash
#!/bin/bash

ID=$1

while true
do
    [[ $(nmcli -f STATE -t g) == "connected" ]] && {
        NET="CONNECTED"
    } || {
        NET="DISCONNECTED"
    }

    VOL=$(amixer -D pulse sget Master | grep -Po "\[\K(\d+)" | head -n 1)
    BATT=$(cat /sys/class/power_supply/BAT*/capacity)

    DATA=""
    DATA+="| A | $NET | | |"
    DATA+="| B | VOL $VOL% | | |"
    DATA+="| C | BATT $BATT% | | |"

    qdbus org.kde.plasma.doityourselfbar /id_$ID \
          org.kde.plasma.doityourselfbar.pass "$DATA"

    sleep 10s
done
```

#### Interactive quick actions widget

```bash
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
```

Note: In order to get it look like on the screenshot:

1. Add the plasmoid to a Latte Dock instance
2. Adjust the dock's settings (left edge, item size 38 px)
3. Open applet's config dialog and the Appearance tab
4. Set horizontal and vertical margins and spacing to 6 px
5. Set fa-solid-900 as a custom font for block labels
6. Set the custom font size for block labels to 24 px or larger
7. Choose Block as a style for block indicators
8. Adjust the block label and indicator colors to your liking

### Other widgets and script examples

As for other examples, not necessarily involving Bash scripts, take a look at the `examples` directory and the `contrib` subdirectory within it. There might be some interesting things inside. And if you managed to do something really cool and useful on your own, you can send a pull request to get the thing merged, and I'll probably accept it.

Also, if you are interested in using the Do It Yourself Bat plasmoid with KWin scripts, see the [Simple Window Groups](https://github.com/wsdfhjxc/kwin-scripts) KWin script, which utilizes the applet to provide a dynamically updated Pager-like panel widget for the user. The most interesting part, in regard to code snippets, is located [here](https://github.com/wsdfhjxc/kwin-scripts/blob/master/simple-window-groups/contents/code/main.js#L98-L133). You can do a similar thing in your own KWin scripts.
