import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "CardSlotTests"

    CardSlot {
        id: cardSlotForTesting
    }

    function test_default_values() {
        compare(cardSlotForTesting.width, 80)
        compare(cardSlotForTesting.height, 120)
        compare(cardSlotForTesting.border.width, 4)
    }
}
