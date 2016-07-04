import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "CardTests"
    width: 800
    height:480
    when: windowShown

    Card {
        x: 100
        y: 120
        id: cardForTesting
        z: 2
    }

    Card {
        x: 200
        y: 250
        id: cardForLinking
        z: 1
    }

    function init_data() {
        cardForTesting.belowMe = null;
        cardForTesting.aboveMe = null;
        cardForTesting.z = 2;
        cardForTesting.faceDown = true;
        cardForLinking.belowMe = null;
        cardForLinking.aboveMe = null;
        cardForLinking.z = 1;
        cardForLinking.faceDown = true;
    }

    function test_default_values() {
        compare(cardForTesting.belowMe, null)
        compare(cardForTesting.aboveMe, null)
        cardForTesting.belowMe = cardForLinking;
        cardForTesting.aboveMe = cardForLinking;
        compare(cardForTesting.belowMe, cardForLinking)
        compare(cardForTesting.aboveMe, cardForLinking)
    }

    function test_onClicked() {
        cardForTesting.faceDown = true;
        cardForTesting.clicked(10, 10, Qt.leftButton, Qt.NoModifier, 10);
        compare(cardForTesting.faceDown, false)
        cardForTesting.clicked(10, 10, Qt.leftButton, Qt.NoModifier, 10);
        compare(cardForTesting.faceDown, true)
    }
}
