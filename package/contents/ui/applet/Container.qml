import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common/Utils.js" as Utils

GridLayout {
    rowSpacing: 0
    columnSpacing: 0
    flow: isVerticalOrientation ?
          GridLayout.TopToBottom :
          GridLayout.LeftToRight

    property var blockButtonList: []

    property Item largestBlockButton

    BlockButton { id: blockButtonComponent }

    GridLayout {
        id: blockButtonContainer
        rowSpacing: parent.rowSpacing
        columnSpacing: parent.columnSpacing
        flow: parent.flow
    }

    function update(blockInfoList) {
        var difference = blockInfoList.length - blockButtonList.length;
        var synchronousUpdate = true;

        if (difference > 0) {
            addBlockButtons(difference);
        } else if (difference < 0) {
            removeBlockButtons(difference, blockInfoList);
            synchronousUpdate = !config.AnimationsEnable;
        }

        if (synchronousUpdate) {
            updateBlockButtons(blockInfoList);
        }
    }

    function addBlockButtons(difference) {
        while (difference > 0) {
            difference--;
            var blockButton = blockButtonComponent.createObject(blockButtonContainer);
            blockButtonList.push(blockButton);
        }
    }

    function removeBlockButtons(difference, blockInfoList) {
        while (difference < 0) {
            difference++;

            var index = blockButtonList.length - 1;
            var blockButton = blockButtonList[index];
            blockButtonList.splice(index, 1);

            if (largestBlockButton == blockButton) {
                largestBlockButton = null;
            }

            if (config.AnimationsEnable) {
                blockButton.hide(function() {
                    blockButton.destroy();

                    if (difference == 0) {
                        updateBlockButtons(blockInfoList);
                    }
                });
                continue;
            }

            blockButton.destroy();
        }
    }

    function updateBlockButtons(blockInfoList) {
        for (var i = 0; i < blockButtonList.length; i++) {
            var blockButton = blockButtonList[i];
            var blockInfo = blockInfoList[i];
            blockButton.update(blockInfo);
            blockButton.show();
        }
    }

    function updateLargestBlockButton() {
        var temp = largestBlockButton;

        for (var i = 0; i < blockButtonList.length; i++) {
            var blockButton = blockButtonList[i];

            if (!temp || temp._label.implicitWidth < blockButton._label.implicitWidth) {
                temp = blockButton;
            }
        }

        if (temp != largestBlockButton) {
            largestBlockButton = temp;
        }
    }

    function addDefaultBlockButton() {
        var blockInfoList = [];
        blockInfoList.push({
            style: "B",
            labelText: "DIY",
            tooltipText: "Hey, you! Configure me!",
            commandToExecOnClick: ""
        });
        update(blockInfoList);
    }

    function addErrorBlockButton() {
        var blockInfoList = [];
        blockInfoList.push({
            style: "C",
            labelText: "DIY",
            tooltipText: "Invalid data format detected!",
            commandToExecOnClick: ""
        });
        update(blockInfoList);
    }

    Component.onCompleted: addDefaultBlockButton()
}
