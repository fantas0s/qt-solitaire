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
    property bool shuffleButtonVisible: false
    property bool shuffleButtonActive: false
    Component.onCompleted: {
        Logic.createDeck();
    }

    Button {
        id: shuffleButton
        x: mainWindow.width - mainWindow.menuButtonWidth - width
        anchors.top: parent.top
        text: qsTr("TR_Shuffle") + LanguageSelector.bindingString
        visible: shuffleButtonVisible
        onClicked: {
            Logic.redeal();
        }
        style: DeactivableButtonStyle {
            active: shuffleButtonActive
        }
    }
}
