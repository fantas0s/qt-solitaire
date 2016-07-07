import QtQuick 2.2

Rectangle {
    id: cardPlaceHolder
    width: 80
    height: 120
    border.width: 4
    color: "transparent"
    property bool aceMarkerVisible: false
    property Item aboveMe: null
    Text {
        id: aceMarker
        anchors.centerIn: parent
        visible: cardPlaceHolder.aceMarkerVisible
        text: "A"
        color: "#808080"
        font.pixelSize: 80
    }
}
