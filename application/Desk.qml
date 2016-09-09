import QtQuick 2.2
import QtQuick.Controls 1.4
import qtsolitaire.languageselector 1.0
import "logic.js" as Logic

Rectangle {
    id: _desk
    color: "green"
    function startGame(gameId) {
        Logic.deleteSlots();
        return Logic.startGame(gameId);
    }
    function cardReadyToAnchor(index, applyRuling) {
        if( Logic.cardReadyToAnchor(index, applyRuling) )
        {
            if( Logic.initialSlotsEmpty() )
            {
                gameCompleteCongratulations.visible = true;
                gameCompleteCongratulations.isPlaying = true;
            }
            return true;
        }
        return false;
    }
    property bool shuffleButtonVisible: false
    property bool shuffleButtonActive: false
    Component.onCompleted: {
        Logic.createDeck();
    }

    Button {
        id: shuffleButton
        x: mainArea.contentWidth - mainArea.menuButtonWidth - width
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

    GameCompeleteBanner {
        id: gameCompleteCongratulations
        anchors.centerIn: parent
        visible: false
        isPlaying: false
        z: parent.z + 1000
    }
}
