import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "SuiteIconTests"
    width: 800
    height: 480
    when: windowShown

    Suiteicon {
        id: testableIcon
    }

    function test_default_values() {
        compare(testableIcon.suite, "heart")
        compare(testableIcon.number, 1)
        compare(testableIcon.width, 10)
    }
}
