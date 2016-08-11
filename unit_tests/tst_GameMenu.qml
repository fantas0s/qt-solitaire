import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "MenuTests"
    width: 800
    height: 480
    when: windowShown
    property int newGameTriggers: 0
    property string selectedLanguage: ""

    GameMenu {
        id: testMenu
        onStartNewGame: {
            newGameTriggers++;
        }
        onLanguageChanged: {
            selectedLanguage = language;
        }
    }

    function init() {
        newGameTriggers = 0;
        selectedLanguage = "";
    }

    function cleanup() {
        compare(newGameTriggers, 0)
        compare(selectedLanguage, "")
    }

    function test_default_values() {
        compare(testMenu.newGameAvailable, false)
        compare(testMenu.title, qsTr("TR_Menu"))
        compare(testMenu.items[0].text, qsTr("TR_Start New Game"))
        compare(testMenu.items[0].enabled, false)
        compare(testMenu.items[1].title, qsTr("TR_Language"))
        compare(testMenu.items[1].items[0].text, qsTr("TR_English"))
        compare(testMenu.items[1].items[1].text, qsTr("TR_Finnish"))
    }

    function test_new_game() {
        testMenu.newGameAvailable = true;
        testMenu.items[0].triggered()
        compare(newGameTriggers, 1)
        newGameTriggers--;
    }

    function test_language_change() {
        testMenu.items[1].items[0].triggered()
        compare(selectedLanguage, "en")
        testMenu.items[1].items[1].triggered()
        compare(selectedLanguage, "fi")
        selectedLanguage = "";
    }
}
