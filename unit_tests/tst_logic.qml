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
        z: 10
    }
    Card {
        id: cardForMatching
        x: 1
        y: 1
        z: 15
    }

    Desk {
        id: mainObject
    }

    function test_toIndex() {
        compare(Logic.toIndex(0,0), 0)
    }
    function test_anchorCardOverOther() {
        compare(Logic.anchorCardOverOther(undefined, undefined, 0), false)
        compare(Logic.anchorCardOverOther(cardForTesting, cardForTesting, 0), false)
        compare(cardForTesting.z, 10)
        compare(cardForMatching.z, 15)
        compare(cardForMatching.anchors.centerIn, null)
        compare(cardForMatching.anchors.verticalCenterOffset, 0)
        compare(Logic.anchorCardOverOther(cardForMatching, cardForTesting, 99), true)
        compare(cardForMatching.z, cardForTesting.z+1)
        cardForTesting.z = 20;
        compare(cardForMatching.z, 21)
        compare(cardForMatching.anchors.centerIn, cardForTesting)
        compare(cardForMatching.anchors.verticalCenterOffset, 99)
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

    function test_startFreeRange() {
        compare(Logic.cardSlots[0], undefined);
        Logic.startFreeRange();
        compare(Logic.cardSlots[0].x, Logic.firstColumnX);
        compare(Logic.cardSlots[0].y, Logic.firstGameAreaRowY);
        compare(Logic.cardSlots[0].aceMarkerVisible, false);
        compare(Logic.cardSlots[6].x, Logic.firstColumnX+(6*Logic.deltaX));
        compare(Logic.cardSlots[6].y, Logic.firstGameAreaRowY);
        compare(Logic.cardSlots[6].aceMarkerVisible, false);
        compare(Logic.cardSlots[7].x, Logic.firstColumnX);
        compare(Logic.cardSlots[7].y, Logic.firstRowY);
        compare(Logic.cardSlots[7].aceMarkerVisible, true);
        compare(Logic.cardSlots[10].x, Logic.firstColumnX+(3*Logic.deltaX));
        compare(Logic.cardSlots[10].y, Logic.firstRowY);
        compare(Logic.cardSlots[10].aceMarkerVisible, true);
    }
}
