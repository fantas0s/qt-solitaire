import QtQuick 2.2
import qtsolitaire.gamelistmodel 1.0
import qtsolitaire.languageselector 1.0

Rectangle {
    id: _chooserRoot
    color: "green"
    signal gameSelected(string gameId)
    GameListModel {
        id: _model
        property string languageDummy: qsTr("TR_DummyBinding") + LanguageSelector.bindingString
        onLanguageDummyChanged: {
            forceUpdate();
        }
    }
    PathView {
        id: _view
        anchors.fill: parent
        model:_model
        delegate: GameChooseDelegate {}
        path: Path {
            startX: 400
            startY: 300
            PathAttribute { name: "itemScale"; value: 1.0 }
            PathAttribute { name: "itemZ"; value: 100 }
            PathQuad { x: 400; y: 180; controlX: 1000; controlY: 240 }
            PathAttribute { name: "itemScale"; value: 0.3 }
            PathAttribute { name: "itemZ"; value: 1 }
            PathQuad { x: 400; y: 300; controlX: -200; controlY: 240 }
            PathAttribute { name: "itemScale"; value: 1.0 }
            PathAttribute { name: "itemZ"; value: 100 }
        }
    }
}
