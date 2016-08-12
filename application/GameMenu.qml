import QtQuick 2.2
import QtQuick.Controls 1.4
import qtsolitaire.languageselector 1.0

Menu {
    id: _rootMenu
    property bool newGameAvailable: false
    signal startNewGame()
    signal languageChanged(string language)
    title: qsTr("TR_Menu")
    MenuItem {
        text: qsTr("TR_Start New Game") + LanguageSelector.bindingString
        enabled: _rootMenu.newGameAvailable
        onTriggered: _rootMenu.startNewGame()
    }
    Menu {
        id: _languageMenu
        title: qsTr("TR_Language") + LanguageSelector.bindingString
        MenuItem {
            text: qsTr("TR_English") + LanguageSelector.bindingString
            onTriggered: _rootMenu.languageChanged("en")
         }
         MenuItem {
             text: qsTr("TR_Finnish") + LanguageSelector.bindingString
             onTriggered: _rootMenu.languageChanged("fi")
         }
    }
}
