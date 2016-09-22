import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    id: mainWindow
    name: "DeskTests"
    width: 800
    height: 479
    when: windowShown
    property int menuButtonWidth: 80

    Item {
        id: mainArea
        Desk {
            id: mainObject
        }
    }
    function test_default_values() {
        compare(mainObject.color, "#008000");
        compare(mainObject.gameAreaHeight, mainWindow.height);
        compare(mainObject.shuffleButtonVisible, false);
        compare(mainObject.shuffleButtonActive, false);
    }
}
