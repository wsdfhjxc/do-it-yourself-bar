import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common" as UICommon

Item {
    // D-Bus service
    property alias cfg_DBusInstanceId: dbusInstanceIdSpinBox.value

    // Startup script
    property string cfg_StartupScriptPath

    GridLayout {
        columns: 1

        SectionHeader {
            text: "D-Bus service"
        }

        RowLayout {
            Label {
                text: "Instance ID:"
            }

            SpinBox {
                id: dbusInstanceIdSpinBox
                minimumValue: 0
                maximumValue: 999
            }

            HintIcon {
                visible: cfg_DBusInstanceId == 0
                tooltipText: "The ID must be a NON-ZERO number"
            }
        }

        RowLayout {
            Label {
                text: "D-Bus service status:"
            }

            Label {
                text: plasmoid.configuration.DBusSuccess ? "OK" : "NOT OK"
                color: plasmoid.configuration.DBusSuccess ? "green" : "red"
            }

            HintIcon {
                tooltipText: {
                    if (plasmoid.configuration.DBusSuccess) {
                        return "You can now pass data to this applet instance"
                    }
                    return plasmoid.configuration.DBusInstanceId == 0 ?
                           "The ID must be a NON-ZERO number" :
                           "There might be a collision, try with a different ID number"
                }
            }
        }

        SectionHeader {
            text: "Startup script"
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: startupScriptPathCheckBox
                checked: cfg_StartupScriptPath
                onCheckedChanged: {
                    if (!checked) {
                        cfg_StartupScriptPath = "";
                    }
                }
                text: "Run this script at startup:"
            }

            UICommon.GrowingTextField {
                id: startupScriptPathTextField
                enabled: startupScriptPathCheckBox.checked
                text: cfg_StartupScriptPath || ""
                onTextChanged: {
                    if (cfg_StartupScriptPath && text) {
                        cfg_StartupScriptPath = text;
                    }
                }
                onEditingFinished: cfg_StartupScriptPath = text
            }

            Item {
                width: 5
            }

            HintIcon {
                visible: startupScriptPathCheckBox.checked
                tooltipText: "Provide a FULL path to the script (no <tt>~</tt> or <tt>$HOME</tt>)<br><br>
                             An argument containing the ID will be passed to the script<br>
                             You can access it within the script by reading the <tt>$1</tt> variable"
            }
        }
    }
}
