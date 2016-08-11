import QtQuick 2.2
import QtQuick.Controls 1.4

Menu {
    id: _rootMenu
    property bool newGameAvailable: false
    signal startNewGame()
    signal languageChanged(string language)
    title: qsTr("TR_Menu")
    MenuItem {
        text: qsTr("TR_Start New Game")
        enabled: _rootMenu.newGameAvailable
        onTriggered: _rootMenu.startNewGame()
    }
    Menu {
        id: _languageMenu
        title: qsTr("TR_Language")
        MenuItem {
            text: qsTr("TR_English")
            onTriggered: _rootMenu.languageChanged("en")
         }
         MenuItem {
             text: qsTr("TR_Finnish")
             onTriggered: _rootMenu.languageChanged("fi")
         }
    }
}
