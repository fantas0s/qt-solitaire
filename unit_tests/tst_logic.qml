import QtQuick 2.2
import QtTest 1.0
import "../application/logic.js" as Logic
import "../application"

TestCase {
    name: "LogicTests"

    Card {
        id: cardForTesting
        x: 1
        y: 1
    }
    Card {
        id: cardForMatching
        x: 1
        y: 1
    }

    function test_default_values() {
        compare(Logic.toIndex(0,0), 0)
    }
    function test_anchorCardOverOther() {
        compare(Logic.anchorCardOverOther(undefined, undefined), false)
        compare(Logic.anchorCardOverOther(cardForTesting, cardForTesting), false)
        compare(Logic.anchorCardOverOther(cardForMatching, cardForTesting), true)
    }

    function test_cardReadyToAnchor()
    {
        Logic.deck[0] = cardForTesting;
        for( var index = 1 ; index < 52 ; index++ )
        {
            Logic.deck[index] = cardForMatching;
        }
        compare(Logic.cardReadyToAnchor(0), false)
    }
}
