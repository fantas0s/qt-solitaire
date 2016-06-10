import QtQuick 2.2
import QtQuick.Window 2.2
//import "logiikka.js" as Logic

Window {
    visible:true
    width: 800
    height: 480

    Rectangle {
        id: mainObject
        anchors.fill: parent
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
//                    Logic.startFreeRange();
                    startButton.visible = false;
                }
            }
        }

        function cardReadyToAnchor(tunniste) {
//            Logic.cardReadyToAnchor(tunniste);
        }
    }
}
