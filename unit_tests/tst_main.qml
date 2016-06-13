import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "MainTests"

    function test_default_values() {
        compare(color, "white");
    }
}
