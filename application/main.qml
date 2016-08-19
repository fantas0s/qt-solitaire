import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import qtsolitaire.languageselector 1.0

Window {
    visible:true
    width: 800
    height: 480

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: mainObject
        Component.onCompleted: {
            stack.push(chooser)
            mainMenu.newGameAvailable = false;
        }
        Desk {
            id: mainObject
        }
        GameChooser {
            id: chooser
            onGameSelected: {
                if( mainObject.startGame(gameId) )
                {
                    mainMenu.newGameAvailable = true;
                    stack.pop();
                }
            }
        }
    }

    Button {
        id: menuButton
        anchors.right: parent.right
        anchors.top: parent.top
        text: qsTr("TR_Menu") + LanguageSelector.bindingString
        onClicked: {
            mainMenu.popup();
        }
    }

    GameMenu {
        id: mainMenu
        onStartNewGame: {
            stack.push(chooser);
        }
        onLanguageChanged: {
            LanguageSelector.languageChange(language)
        }
    }
}
