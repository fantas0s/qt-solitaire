import QtQuick 2.2

Rectangle {
    id: _chooserRoot
    color: "green"
    signal gameSelected(string gameName)
    PathView {
        id: _view
        anchors.fill: parent
        model: GameChooseModel {}
        delegate: GameChooseDelegate {}
        path: Path {
            startX: 400
            startY: 180
            PathAttribute { name: "itemScale"; value: 0.3 }
            PathAttribute { name: "itemZ"; value: 1 }
            PathQuad { x: 400; y: 300; controlX: 750; controlY: 240 }
            PathAttribute { name: "itemScale"; value: 1.0 }
            PathAttribute { name: "itemZ"; value: 100 }
            PathQuad { x: 400; y: 180; controlX: 50; controlY: 240 }
            PathAttribute { name: "itemScale"; value: 0.3 }
            PathAttribute { name: "itemZ"; value: 1 }
        }
    }
}
