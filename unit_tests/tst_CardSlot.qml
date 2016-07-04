import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "CardSlotTests"
    width: 800
    height:480
    when: windowShown

    CardSlot {
        id: cardSlotForTesting
    }

    function test_default_values() {
        compare(cardSlotForTesting.width, 80)
        compare(cardSlotForTesting.height, 120)
        compare(cardSlotForTesting.border.width, 4)
        compare(cardSlotForTesting.border.color, "#000000")
        compare(cardSlotForTesting.color, "#00000000")
        compare(cardSlotForTesting.aceMarkerVisible, false)
    }
}
