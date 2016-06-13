import QtQuick 2.2
import "logic.js" as Logic

Rectangle {
    color: "green"
    Rectangle {
        id: startButton
        width: 200
        height: 50
        border.color: "black"
        border.width: 3
        Text {
            anchors.fill: parent
            text: "Start"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Logic.startFreeRange();
                startButton.visible = false;
            }
        }
    }

    function cardReadyToAnchor(tunniste) {
        return Logic.cardReadyToAnchor(tunniste);
    }
}
