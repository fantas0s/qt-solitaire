import QtQuick 2.2

Column {
    id: _delegateRoot
    scale: PathView.itemScale
    z: PathView.itemZ
    signal gameSelected(string gameId)
    Image {
        id: _solitaireImage
        source: imageFile
        MouseArea {
            anchors.fill: parent
            onClicked: {
                _chooserRoot.gameSelected(solitaireId)
            }
        }
    }
    Text {
        id: _solitaireName
        anchors.horizontalCenter: _solitaireImage.horizontalCenter
        text: solitaireName
    }
}
