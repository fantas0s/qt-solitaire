import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Enterprise.VirtualKeyboard 1.0

Window {
    visible:true
    width: Screen.width
    height: Screen.height

    Item {
        id: root
        anchors.fill: parent

        Text {
            id: text
            text: qsTr("Hello World")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 100
            anchors.top: parent.top
        }

        Rectangle {
            height: text.height * 1.2
            width: text.width * 3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: text.bottom
            anchors.topMargin: 20
            border.width: 2
            radius: 4
            border.color: "blue"

            TextInput {
                anchors.fill: parent
                anchors.margins: 4
                text: "Text input, please type here"
            }
        }

        InputPanel {
            id: inputPanel
            z: 99
            y: root.height
            anchors.left: root.left
            anchors.right: root.right

            states: State {
                name: "visible"
                when: Qt.inputMethod.visible
                PropertyChanges {
                    target: inputPanel
                    y: root.height - inputPanel.height
                }
            }
            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
