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

    function setButtonsEnabledState(newState) {
        menuButton.enabled = newState;
        shuffleButton.enabled = newState;
    }

    function cardReadyToAnchor(index, applyRuling) {
        if( Logic.cardReadyToAnchor(index, applyRuling) )
        {
            if( Logic.gameIsComplete() )
            {
                gameCompleteCongratulations.visible = true;
                gameCompleteCongratulations.isPlaying = true;
                setButtonsEnabledState(false);
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
        x: (mainWindow.width / 2) - (width / 2)
        y: (mainWindow.height / 2) - (height / 2)
        visible: false
        isPlaying: false
        z: parent.z + 1000
        MouseArea {
            anchors.centerIn: parent
            width: mainWindow.width
            height: mainWindow.height
            onClicked: {
                setButtonsEnabledState(true);
                gameCompleteCongratulations.visible = false;
            }
        }
    }
}
