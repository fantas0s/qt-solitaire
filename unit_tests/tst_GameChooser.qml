import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "GameChooserTests"
    width: 800
    height: 480
    when: windowShown

    GameChooser {
        id: chooserToTest
    }

    function test_default_values() {
        compare(chooserToTest.color, "#008000");
    }
}
