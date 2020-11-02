import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common" as UICommon

Item {
    // D-Bus service
    property alias cfg_DBusInstanceId: dbusInstanceIdSpinBox.value

    GridLayout {
        columns: 1

        SectionHeader {
            text: "D-Bus service "
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
                tooltipText: "The ID must be a NON-ZERO number different from IDs of other running instances"
            }
        }

        RowLayout {
            Label {
                text: "D-Bus service status:"
            }

            Label {
                text: plasmoid.configuration.DBusSuccess ? "RUNNING" : "STOPPED"
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
    }
}
