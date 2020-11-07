import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore

import "../common" as UICommon

Item {
    // Animations
    property alias cfg_AnimationsEnable: animationsEnableCheckBox.checked

    // Block buttons
    property alias cfg_BlockButtonsVerticalMargin: blockButtonsVerticalMarginSpinBox.value
    property alias cfg_BlockButtonsHorizontalMargin: blockButtonsHorizontalMarginSpinBox.value
    property alias cfg_BlockButtonsSpacing: blockButtonsSpacingSpinBox.value
    property alias cfg_BlockButtonsSetCommonSizeForAll: blockButtonsSetCommonSizeForAllCheckBox.checked

    // Block labels
    property alias cfg_BlockLabelsMaximumLength: blockLabelsMaximumLengthSpinBox.value
    property string cfg_BlockLabelsCustomFont
    property int cfg_BlockLabelsCustomFontSize
    property string cfg_BlockLabelsCustomColor

    // Block indicators
    property alias cfg_BlockIndicatorsStyle: blockIndicatorsStyleComboBox.currentIndex
    property alias cfg_BlockIndicatorsInvertPosition: indicatorsInvertPositionCheckBox.checked
    property string cfg_BlockIndicatorsCustomColorForStyleA
    property string cfg_BlockIndicatorsCustomColorForStyleB
    property string cfg_BlockIndicatorsCustomColorForStyleC

    GridLayout {
        columns: 1

        SectionHeader {
            text: "Animations"
        }

        CheckBox {
            id: animationsEnableCheckBox
            text: "Enable animations"
        }

        SectionHeader {
            text: "Buttons"
        }

        RowLayout {
            Label {
                text: "Vertical margins:"
            }

            SpinBox {
                id: blockButtonsVerticalMarginSpinBox

                enabled: cfg_BlockIndicatorsStyle != 0 &&
                         cfg_BlockIndicatorsStyle != 4 &&
                         cfg_BlockIndicatorsStyle != 5

                value: cfg_BlockButtonsVerticalMargin
                minimumValue: 0
                maximumValue: 300
                suffix: " px"
            }

            HintIcon {
                visible: !blockButtonsVerticalMarginSpinBox.enabled
                tooltipText: "Not available for the selected indicator style"
            }
        }

        RowLayout {
            Label {
                text: "Horizontal margins:"
            }

            SpinBox {
                id: blockButtonsHorizontalMarginSpinBox
                enabled: cfg_BlockIndicatorsStyle != 5
                value: cfg_BlockButtonsHorizontalMargin
                minimumValue: 0
                maximumValue: 300
                suffix: " px"
            }

            HintIcon {
                visible: !blockButtonsHorizontalMarginSpinBox.enabled
                tooltipText: "Not available for the selected indicator style"
            }
        }

        RowLayout {
            Label {
                text: "Spacing between buttons:"
            }

            SpinBox {
                id: blockButtonsSpacingSpinBox
                value: cfg_BlockButtonsSpacing
                minimumValue: 0
                maximumValue: 100
                suffix: " px"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: blockButtonsSetCommonSizeForAllCheckBox
                text: "Set common size for all buttons"
            }

            HintIcon {
                tooltipText: "The size is based on the largest button"
            }
        }

        SectionHeader {
            text: "Labels"
        }

        RowLayout {
            Label {
                text: "Maximum length:"
            }

            SpinBox {
                id: blockLabelsMaximumLengthSpinBox
                minimumValue: 3
                maximumValue: 100
                suffix: " chars"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: labelsCustomFontCheckBox
                checked: cfg_BlockLabelsCustomFont
                onCheckedChanged: {
                    if (checked) {
                        var currentIndex = labelsCustomFontComboBox.currentIndex;
                        var selectedFont = labelsCustomFontComboBox.model[currentIndex].value;
                        cfg_BlockLabelsCustomFont = selectedFont;
                    } else {
                        cfg_BlockLabelsCustomFont = "";
                    }
                }
                text: "Custom font:"
            }

            ComboBox {
                id: labelsCustomFontComboBox
                enabled: labelsCustomFontCheckBox.checked
                implicitWidth: 130

                Component.onCompleted: {
                    var array = [];
                    var fonts = Qt.fontFamilies()
                    for (var i = 0; i < fonts.length; i++) {
                        array.push({text: fonts[i], value: fonts[i]});
                    }
                    model = array;

                    var foundIndex = find(cfg_BlockLabelsCustomFont);
                    if (foundIndex == -1) {
                        foundIndex = find(theme.defaultFont.family);
                    }
                    if (foundIndex >= 0) {
                        currentIndex = foundIndex;
                    }
                }

                onCurrentIndexChanged: {
                    if (enabled && currentIndex) {
                        var selectedFont = model[currentIndex].value;
                        cfg_BlockLabelsCustomFont = selectedFont;
                    }
                }
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: labelsCustomFontSizeCheckBox
                checked: cfg_BlockLabelsCustomFontSize > 0
                onCheckedChanged: cfg_BlockLabelsCustomFontSize = checked ?
                                  labelsCustomFontSizeSpinBox.value : 0
                text: "Custom font size:"
            }

            SpinBox {
                id: labelsCustomFontSizeSpinBox
                enabled: labelsCustomFontSizeCheckBox.checked
                value: cfg_BlockLabelsCustomFontSize || theme.defaultFont.pixelSize
                minimumValue: 5
                maximumValue: 100
                suffix: " px"
                onValueChanged: {
                    if (labelsCustomFontSizeCheckBox.checked) {
                        cfg_BlockLabelsCustomFontSize = value;
                    }
                }
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: labelsCustomColorCheckBox
                enabled: cfg_BlockIndicatorsStyle != 5
                checked: cfg_BlockLabelsCustomColor
                onCheckedChanged: cfg_BlockLabelsCustomColor = checked ?
                                  labelsCustomColorButton.color : ""
                text: "Custom text color:"
            }

            ColorButton {
                id: labelsCustomColorButton
                enabled: labelsCustomColorCheckBox.checked
                color: cfg_BlockLabelsCustomColor || theme.textColor

                colorAcceptedCallback: function(color) {
                    cfg_BlockLabelsCustomColor = color;
                }
            }

            Item {
                width: 8
            }

            HintIcon {
                visible: labelsCustomColorCheckBox.checked ||
                         !labelsCustomColorCheckBox.enabled
                tooltipText: cfg_BlockIndicatorsStyle != 5 ?
                             "Click the colored box to choose a different color" :
                             "Not available if labels are used as indicators"
            }
        }

        SectionHeader {
            text: "Indicators"
        }

        RowLayout {
            Label {
                text: "Style:"
            }

            ComboBox {
                id: blockIndicatorsStyleComboBox
                implicitWidth: 100
                model: [
                    "Edge line",
                    "Side line",
                    "Block",
                    "Rounded",
                    "Full size",
                    "Use labels"
                ]
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: indicatorsInvertPositionCheckBox
                enabled: cfg_BlockIndicatorsStyle < 2
                text: "Invert indicator's position"
            }

            HintIcon {
                visible: !indicatorsInvertPositionCheckBox.enabled
                tooltipText: "Not available for the selected indicator style"
            }
        }

        RowLayout {
            CheckBox {
                id: indicatorsCustomColorForStyleACheckBox
                checked: cfg_BlockIndicatorsCustomColorForStyleA
                onCheckedChanged: cfg_BlockIndicatorsCustomColorForStyleA = checked ?
                                  indicatorsCustomColorForStyleAButton.color : ""
                text: "Custom color for style A:"
            }

            ColorButton {
                id: indicatorsCustomColorForStyleAButton
                enabled: indicatorsCustomColorForStyleACheckBox.checked
                color: cfg_BlockIndicatorsCustomColorForStyleA || theme.textColor

                colorAcceptedCallback: function(color) {
                    cfg_BlockIndicatorsCustomColorForStyleA = color;
                }
            }
        }

        RowLayout {
            CheckBox {
                id: indicatorsCustomColorForStyleBCheckBox
                checked: cfg_BlockIndicatorsCustomColorForStyleB
                onCheckedChanged: cfg_BlockIndicatorsCustomColorForStyleB = checked ?
                                  indicatorsCustomColorForStyleBButton.color : ""
                text: "Custom color for style B:"
            }

            ColorButton {
                id: indicatorsCustomColorForStyleBButton
                enabled: indicatorsCustomColorForStyleBCheckBox.checked
                color: cfg_BlockIndicatorsCustomColorForStyleB || theme.buttonFocusColor

                colorAcceptedCallback: function(color) {
                    cfg_BlockIndicatorsCustomColorForStyleB = color;
                }
            }
        }

        RowLayout {
            CheckBox {
                id: indicatorsCustomColorForStyleCCheckBox
                checked: cfg_BlockIndicatorsCustomColorForStyleC
                onCheckedChanged: cfg_BlockIndicatorsCustomColorForStyleC = checked ?
                                  indicatorsCustomColorForStyleCButton.color : ""
                text: "Custom color for style C:"
            }

            ColorButton {
                id: indicatorsCustomColorForStyleCButton
                enabled: indicatorsCustomColorForStyleCCheckBox.checked
                color: cfg_BlockIndicatorsCustomColorForStyleC || "#a35050"

                colorAcceptedCallback: function(color) {
                    cfg_BlockIndicatorsCustomColorForStyleC = color;
                }
            }
        }
    }
}
