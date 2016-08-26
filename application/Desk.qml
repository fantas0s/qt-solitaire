import QtQuick 2.2
import QtQuick.Controls 1.4
import qtsolitaire.languageselector 1.0
import "logic.js" as Logic

Rectangle {
    color: "green"
    function startGame(gameId) {
        Logic.deleteSlots();
        return Logic.startGame(gameId);
    }
    function cardReadyToAnchor(index, applyRuling) {
        return Logic.cardReadyToAnchor(index, applyRuling);
    }
    Component.onCompleted: {
        Logic.createDeck();
    }
    Button {
        id: shuffleButton
        x: mainWindow.width - mainWindow.menuButtonWidth - width
        anchors.top: parent.top
        text: qsTr("TR_Shuffle") + LanguageSelector.bindingString
        onClicked: {
            Logic.redeal();
        }
    }

}
