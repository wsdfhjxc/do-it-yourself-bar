import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import org.kde.plasma.doityourselfbar 1.0

Item {
    id: root

    Plasmoid.fullRepresentation: RowLayout {
        Label {
            text: "Hello"
        }
    }
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property QtObject config: plasmoid.configuration

    property bool isTopLocation: plasmoid.location == PlasmaCore.Types.TopEdge
    property bool isVerticalOrientation: plasmoid.formFactor == PlasmaCore.Types.Vertical

    DoItYourselfBar {
        id: backend

        cfg_DBusInstanceId: config.DBusInstanceId
    }

    Connections {
        target: backend

        // Because plasmoid.nativeInterface is unavailable for this kind
        // of a plugin (must be a Plasma::Applet library or something),
        // a hack is needed to be able to detect the success in the config
        // dialog, so I use an additional config property and update it
        // with a value received from the C++ backend. This causes the config
        // dialog to read this property and show D-Bus service status.
        onDbusSuccessChanged: config.DBusSuccess = dbusSuccess
    }
}
