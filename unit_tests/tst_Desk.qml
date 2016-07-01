import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "DeskTests"

    Desk {
        id: deskToTest
    }

    function test_default_values() {
        compare(deskToTest.color, "#008000");
    }
}
