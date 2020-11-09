import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common/Utils.js" as Utils

Component {
    Rectangle {
        property string style: ""
        property string labelText: ""
        property string tooltipText: ""
        property string commandToExecOnClick: ""

        property alias _label: label
        property alias _indicator: indicator

        Layout.fillWidth: isVerticalOrientation
        Layout.fillHeight: !isVerticalOrientation

        clip: true
        color: "transparent"
        opacity: !config.AnimationsEnable ? 1 : 0

        readonly property int tooltipWaitDuration: 800
        readonly property int animationWidthDuration: 100
        readonly property int animationColorDuration: 150
        readonly property int animationOpacityDuration: 150

        Behavior on opacity {
            enabled: config.AnimationsEnable
            animation: NumberAnimation {
                duration: animationOpacityDuration
            }
        }

        Behavior on implicitWidth {
            enabled: config.AnimationsEnable
            animation: NumberAnimation {
                duration: animationWidthDuration
                onRunningChanged: {
                    if (!running) {
                        Utils.delay(100, container.updateLargestBlockButton);
                    }
                }
            }
        }

        Behavior on implicitHeight {
            enabled: config.AnimationsEnable
            animation: NumberAnimation {
                duration: animationWidthDuration
            }
        }

        /* Indicator */
        Rectangle {
            id: indicator

            readonly property int lineWidth: 3

            visible: config.BlockIndicatorsStyle != 5

            color: {
                if (style == "A") {
                    return config.BlockIndicatorsCustomColorForStyleA || theme.textColor;
                }
                if (style == "B") {
                    return config.BlockIndicatorsCustomColorForStyleB || theme.buttonFocusColor;
                }
                if (style == "C") {
                    return config.BlockIndicatorsCustomColorForStyleC || "#e34a4a";
                }
                return theme.textColor;
            }

            Behavior on color {
                enabled: config.AnimationsEnable
                animation: ColorAnimation {
                    duration: animationColorDuration
                }
            }

            width: {
                if (isVerticalOrientation) {
                    if (config.BlockIndicatorsStyle == 1) {
                        return lineWidth;
                    }
                    if (config.BlockIndicatorsStyle == 4) {
                        return parent.width;
                    }
                    if (config.BlockButtonsSetCommonSizeForAll &&
                        container.largestBlockButton &&
                        container.largestBlockButton != parent &&
                        container.largestBlockButton._label.implicitWidth > label.implicitWidth) {
                        return container.largestBlockButton._indicator.width;
                    }
                    return label.implicitWidth + 2 * config.BlockButtonsHorizontalMargin;
                }
                if (config.BlockIndicatorsStyle == 1) {
                    return lineWidth;
                }
                return parent.width + 0.5 - 2 * config.BlockButtonsSpacing;
            }

            height: {
                if (config.BlockIndicatorsStyle == 4) {
                    if (isVerticalOrientation) {
                        return parent.height + 0.5 - 2 * config.BlockButtonsSpacing;
                    }
                    return parent.height;
                }
                if (config.BlockIndicatorsStyle > 0) {
                    return label.implicitHeight + 2 * config.BlockButtonsVerticalMargin;
                }
                return lineWidth;
            }

            x: {
                if (isVerticalOrientation) {
                    if (config.BlockIndicatorsStyle != 1) {
                        return (parent.width - width) / 2;
                    }
                    return config.BlockIndicatorsInvertPosition ?
                           parent.width - lineWidth : 0;
                }
                if (config.BlockIndicatorsStyle == 1 &&
                    config.BlockIndicatorsInvertPosition) {
                    return parent.width - width - (config.BlockButtonsSpacing || 0);
                }
                return config.BlockButtonsSpacing || 0;
            }

            y: {
                if (config.BlockIndicatorsStyle > 0) {
                    return (parent.height - height) / 2;
                }
                if (isTopLocation) {
                    return !config.BlockIndicatorsInvertPosition ? parent.height - height : 0;
                }
                return !config.BlockIndicatorsInvertPosition ? 0 : parent.height - height;
            }

            radius: {
                if (config.BlockIndicatorsStyle == 2) {
                    return 2;
                }
                if (config.BlockIndicatorsStyle == 3) {
                    return 300;
                }
                return 0;
            }
        }

        /* Label */
        Text {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            text: labelText

            color: {
                if (config.BlockIndicatorsStyle == 5) {
                    return indicator.color;
                }
                if (parent.style == "A") {
                    return config.BlockLabelsCustomColorForStyleA || theme.textColor;
                }
                if (parent.style == "B") {
                    return config.BlockLabelsCustomColorForStyleB || theme.textColor;
                }
                if (parent.style == "C") {
                    return config.BlockLabelsCustomColorForStyleC || theme.textColor;
                }
                return theme.textColor;
            }

            Behavior on color {
                enabled: config.AnimationsEnable
                animation: ColorAnimation {
                    duration: animationColorDuration
                }
            }

            Behavior on opacity {
                enabled: config.AnimationsEnable
                animation: NumberAnimation {
                    duration: animationOpacityDuration
                }
            }

            font.family: config.BlockLabelsCustomFont || theme.defaultFont.family
            font.pixelSize: config.BlockLabelsCustomFontSize || theme.defaultFont.pixelSize
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            property var tooltipTimer

            function killTooltipTimer() {
                if (tooltipTimer) {
                    tooltipTimer.stop();
                    tooltipTimer = null;
                }
            }

            onEntered: {
                if (!tooltipText) {
                    return;
                }
                tooltipTimer = Utils.delay(tooltipWaitDuration, function() {
                    if (containsMouse) {
                        tooltip.show(parent);
                    }
                });
            }

            onExited: {
                if (tooltipText) {
                    killTooltipTimer();
                    tooltip.visible = false;
                }
            }

            onClicked: {
                if (tooltipText) {
                    killTooltipTimer();
                    tooltip.visible = false;
                }
                if (mouse.button == Qt.LeftButton) {
                    backend.runCommand(commandToExecOnClick);
                }
            }
        }

        function updateLabel() {
            label.text = Qt.binding(function() {
                if (labelText.length > config.BlockLabelsMaximumLength) {
                    return labelText.substr(0, config.BlockLabelsMaximumLength - 1) + "…";
                }
                return labelText;
            });
        }

        function update(blockInfo) {
            style = blockInfo.style;
            labelText = blockInfo.labelText;
            tooltipText = blockInfo.tooltipText;
            commandToExecOnClick = blockInfo.commandToExecOnClick;

            updateLabel();
        }

        function show() {
            var self = this;

            implicitWidth = Qt.binding(function() {
                if (isVerticalOrientation) {
                    return parent.width;
                }

                var newImplicitWidth = label.implicitWidth +
                                       2 * config.BlockButtonsHorizontalMargin +
                                       2 * config.BlockButtonsSpacing;

                if (config.BlockButtonsSetCommonSizeForAll &&
                    container.largestBlockButton &&
                    container.largestBlockButton != self &&
                    container.largestBlockButton.implicitWidth > newImplicitWidth) {
                    return container.largestBlockButton.implicitWidth;
                }

                return newImplicitWidth;
            });

            implicitHeight = Qt.binding(function() {
                if (!isVerticalOrientation) {
                    return parent.height;
                }
                return label.implicitHeight +
                       2 * config.BlockButtonsVerticalMargin +
                       2 * config.BlockButtonsSpacing;
            });

            if (config.AnimationsEnable) {
                Utils.delay(animationWidthDuration, function() {
                    opacity = 1;
                });
            }
        }

        function hide(callback) {
            opacity = 0;

            var resetDimensions = function() {
                implicitWidth = isVerticalOrientation ? parent.width : 0;
                implicitHeight = isVerticalOrientation ? 0 : parent.height;
            }

            var postHideCallback = callback ? callback : function() {};

            if (config.AnimationsEnable) {
                Utils.delay(animationOpacityDuration, function() {
                    resetDimensions();
                    Utils.delay(animationWidthDuration, postHideCallback);
                });
                return;
            }

            resetDimensions();
            postHideCallback();
        }

        onImplicitWidthChanged: {
            if (!config.AnimationsEnable) {
                Utils.delay(100, container.updateLargestBlockButton);
            }
        }
    }
}
