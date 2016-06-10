import QtQuick 2.2
import QtQuick.Window 2.2
//import "logic.js" as Logic

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

        //TEMP, REMOVE WHEN CARD IS TESTED!!!
        Card {
            id: middleCard
            myNumber: 12
            mySuite: "diamond"
            anchors.centerIn: parent
        }
        Card {
            myNumber: 1
            mySuite: "spade"
            anchors.left: middleCard.right
            anchors.top: middleCard.top
        }
        Card {
            myNumber: 11
            mySuite: "clubs"
            anchors.right: middleCard.left
            anchors.top: middleCard.top
        }
        Card {
            myNumber: 13
            mySuite: "heart"
            anchors.top: middleCard.bottom
            anchors.left: middleCard.left
        }

        //TEMP, REMOVE WHEN CARD IS TESTED!!!

        function cardReadyToAnchor(tunniste) {
//            Logic.cardReadyToAnchor(tunniste);
        }
    }
}
