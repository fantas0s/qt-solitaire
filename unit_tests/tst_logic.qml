import QtQuick 2.2
import QtTest 1.0
import "../application/logic.js" as Logic
import "../application"

TestCase {
    name: "LogicTests"
    width: 800
    height: 480

    Card {
        id: cardForTesting
        myId: 7
        x: 1
        y: 1
        z: 10
    }
    Card {
        id: cardForMatching
        myId: 9
        x: 1
        y: 1
        z: 15
    }

    Desk {
        id: mainObject
    }

    function init_data() {
        Logic.createDeck();
        Logic.createSlotsForFreeRange();
    }

    function test_1_toIndex() {
        compare(Logic.toIndex(0,0), 0)
        compare(Logic.toIndex(1,12), 26-1)
        compare(Logic.toIndex(3,12), 52-1)
    }

    function test_2_createDeck() {
        // Already created in init_data()
        for( var suite = 0 ; suite < 4 ; suite++ ) {
            for( var number = 0 ; number < 13 ; number++ ) {
                var index = Logic.toIndex(suite, number);
                compare(Logic.deck[index].x, 30)
                compare(Logic.deck[index].y, 5)
                compare(Logic.deck[index].myId, index)
                compare(Logic.deck[index].myNumber, number+1)
                switch( suite )
                {
                case 0:
                    compare(Logic.deck[index].mySuite, "diamond")
                    break;
                case 1:
                    compare(Logic.deck[index].mySuite, "clubs")
                    break;
                case 2:
                    compare(Logic.deck[index].mySuite, "heart")
                    break;
                default:
                    compare(Logic.deck[index].mySuite, "spade")
                    break;
                }
            }
        }
    }

    function test_3_createSlots() {
        // Already created in init_data()
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

    function test_cardReadyToAnchor_idTooLarge()
    {
        compare(Logic.cardReadyToAnchor(52), false)
    }

    function test_cardReadyToAnchor_sameXY()
    {
        Logic.deck[9].x = 400;
        Logic.deck[9].y = 400;
        Logic.deck[23].x = 400;
        Logic.deck[23].y = 400;
        compare(Logic.cardReadyToAnchor(23), false)
    }

    function test_cardReadyToAnchor_overFirstCard()
    {
        Logic.deck[0].x = 400;
        Logic.deck[0].y = 400;
        Logic.deck[51].x = 401;
        Logic.deck[51].y = 401;
        compare(Logic.cardReadyToAnchor(51), true)
        compare(Logic.deck[51].anchors.centerIn, Logic.deck[0])
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.deck[51].x = 400+Logic.deck[0].width-1;
        Logic.deck[51].y = 400+Logic.deck[0].height-1;
        compare(Logic.cardReadyToAnchor(51), true)
        compare(Logic.deck[51].anchors.centerIn, Logic.deck[0])
        compare(Logic.deck[51].anchors.verticalCenterOffset, 5)
    }

    function test_cardReadyToAnchor_overFaceUpCard()
    {
        Logic.deck[16].x = 400;
        Logic.deck[16].y = 400;
        Logic.deck[16].faceDown = false;
        Logic.deck[44].x = 401;
        Logic.deck[44].y = 401;
        compare(Logic.cardReadyToAnchor(44), true)
        compare(Logic.deck[44].anchors.centerIn, Logic.deck[16])
        compare(Logic.deck[44].anchors.verticalCenterOffset, 30)
    }

    function test_cardReadyToAnchor_notOverAnyCard()
    {
        Logic.deck[13].x = 390;
        Logic.deck[13].y = 390;
        Logic.deck[42].x = 389;
        Logic.deck[42].y = 391;
        compare(Logic.cardReadyToAnchor(42), false)
        Logic.deck[42].x = 391;
        Logic.deck[42].y = 389;
        compare(Logic.cardReadyToAnchor(42), false)
        Logic.deck[51].y = 390+Logic.deck[0].height;
        compare(Logic.cardReadyToAnchor(42), false)
        Logic.deck[51].x = 390+Logic.deck[0].width;
        Logic.deck[51].y = 391;
        compare(Logic.cardReadyToAnchor(42), false)
    }

    function test_cardReadyToAnchor_overASlot()
    {
        var slot = Logic.cardSlots[10];
        slot.x = 450;
        slot.y = 450;
        Logic.deck[51].x = 450;
        Logic.deck[51].y = 450;
        compare(Logic.cardReadyToAnchor(51), true)
        compare(Logic.deck[51].anchors.centerIn, slot)
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.deck[51].x = 450+slot.width-1;
        Logic.deck[51].y = 450+slot.height-1;
        compare(Logic.cardReadyToAnchor(51), true)
        compare(Logic.deck[51].anchors.centerIn, slot)
        compare(Logic.deck[51].anchors.verticalCenterOffset, 0)
    }

    function test_cardReadyToAnchor_overACardOverASlot()
    {
        var slot = Logic.cardSlots[10];
        slot.x = 450;
        slot.y = 450;
        Logic.deck[51].x = 450;
        Logic.deck[51].y = 450;
        Logic.cardReadyToAnchor(51)
        Logic.deck[49].x = 450+slot.width-1;
        Logic.deck[49].y = 450+slot.height-1;
        compare(Logic.cardReadyToAnchor(49), true)
        compare(Logic.deck[49].anchors.centerIn, Logic.deck[51])
        compare(Logic.deck[49].anchors.verticalCenterOffset, 5)
    }

    function test_cardReadyToAnchor_notOverAnySlot()
    {
        var slot = Logic.cardSlots[10];
        Logic.deck[42].x = slot.x;
        Logic.deck[42].y = slot.y-1;
        compare(Logic.cardReadyToAnchor(42), false)
        Logic.deck[42].x = slot.x-1;
        Logic.deck[42].y = slot.y;
        compare(Logic.cardReadyToAnchor(42), false)
        Logic.deck[42].x = slot.x+slot.width;
        compare(Logic.cardReadyToAnchor(42), false)
        Logic.deck[42].x = slot.x;
        Logic.deck[42].x = slot.y+slot.height;
        compare(Logic.cardReadyToAnchor(42), false)
    }

    function test_cardReadyToAnchor_chooseHighestZ()
    {
        Logic.deck[16].x = 400;
        Logic.deck[16].y = 400;
        Logic.deck[16].z = 10;
        Logic.deck[17].x = 400;
        Logic.deck[17].y = 400;
        Logic.deck[17].z = 12;
        Logic.deck[18].x = 400;
        Logic.deck[18].y = 400;
        Logic.deck[18].z = 11;
        Logic.deck[39].x = 401;
        Logic.deck[39].y = 401;
        Logic.deck[39].z = 100;
        compare(Logic.cardReadyToAnchor(39), true)
        compare(Logic.deck[39].anchors.centerIn, Logic.deck[17])
        compare(Logic.deck[39].z, Logic.deck[17].z+1)
    }

    function test_startFreeRange() {
        Logic.startFreeRange();
    }
}
