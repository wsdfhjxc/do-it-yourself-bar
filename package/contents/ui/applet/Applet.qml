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
}
