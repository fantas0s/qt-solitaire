import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "DeskTests"
    width: 800
    height: 480
    when: windowShown

    Desk {
        id: mainObject
    }

    function test_default_values() {
        compare(mainObject.color, "#008000");
    }
}
