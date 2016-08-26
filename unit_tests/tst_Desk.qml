import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    id: mainWindow
    name: "DeskTests"
    width: 800
    height: 480
    when: windowShown
    property int menuButtonWidth: 80

    Desk {
        id: mainObject
    }

    function test_default_values() {
        compare(mainObject.color, "#008000");
    }
}
