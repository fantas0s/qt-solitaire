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
    Card {
        id: yetAnotherCard
        myId: 11
        x: 1
        y: 1
        z: 15
    }
    CardSlot {
        id: slotForTesting
    }

    Desk {
        id: mainObject
    }

    function init_data() {
        Logic.createDeck();
        Logic.createSlotsForFathersSolitaire();
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
        compare(Logic.slotCount, 11);
        compare(Logic.cardSlots[0].x, Logic.firstColumnX);
        compare(Logic.cardSlots[0].y, Logic.firstGameAreaRowY);
        compare(Logic.cardSlots[0].isAceSlot, false);
        compare(Logic.cardSlots[6].x, Logic.firstColumnX+(6*Logic.deltaX));
        compare(Logic.cardSlots[6].y, Logic.firstGameAreaRowY);
        compare(Logic.cardSlots[6].isAceSlot, false);
        compare(Logic.cardSlots[7].x, Logic.firstColumnX);
        compare(Logic.cardSlots[7].y, Logic.firstRowY);
        compare(Logic.cardSlots[7].isAceSlot, true);
        compare(Logic.cardSlots[10].x, Logic.firstColumnX+(3*Logic.deltaX));
        compare(Logic.cardSlots[10].y, Logic.firstRowY);
        compare(Logic.cardSlots[10].isAceSlot, true);
    }

    function test_4_deleteSlots() {
        // Slots created in init_data()
        Logic.deleteSlots();
        compare(Logic.slotCount, 0);
        compare(Logic.cardSlots[0], null);
        compare(Logic.cardSlots[10], null);
    }

    function test_5_resetDeck() {
        // Deck created in init_data()
        Logic.resetDeck();
        for( var index = 0 ; index < 52 ; index++ ) {
            var cardToCheck = Logic.deck[index];
            compare(cardToCheck.x, Logic.firstColumnX);
            compare(cardToCheck.y, Logic.firstRowY);
            compare(cardToCheck.z, 10+index);
            compare(cardToCheck.aboveMe, null);
            compare(cardToCheck.belowMe, null);
            compare(cardToCheck.anchors.centerIn, null);
        }
    }

    function test_anchorCardOverOther() {
        compare(Logic.anchorCardOverOther(undefined, undefined, false), false)
        compare(Logic.anchorCardOverOther(cardForTesting, cardForTesting, false), false)
        compare(cardForTesting.z, 10)
        compare(cardForMatching.z, 15)
        compare(cardForMatching.anchors.centerIn, null)
        compare(cardForMatching.anchors.verticalCenterOffset, 0)
        compare(Logic.anchorCardOverOther(cardForMatching, cardForTesting, false), true)
        compare(cardForMatching.z, cardForTesting.z+1)
        cardForTesting.z = 20;
        compare(cardForMatching.z, 21)
        compare(cardForMatching.anchors.centerIn, cardForTesting)
        compare(cardForMatching.anchors.verticalCenterOffset, 5)
        compare(cardForMatching.belowMe, cardForTesting)
        compare(cardForTesting.aboveMe, cardForMatching)
    }

    function test_anchorCardOverOther_MiddleOfStack() {
        cardForTesting.aboveMe = yetAnotherCard;
        compare(Logic.anchorCardOverOther(cardForMatching, cardForTesting, false), false)
        cardForTesting.aboveMe = null;
    }

    function test_anchorCardOverSlot()
    {
        cardForTesting.anchors.verticalCenterOffset = 101;
        compare(Logic.anchorCardOverSlot(cardForTesting, slotForTesting, false), true)
        compare(slotForTesting.aboveMe, cardForTesting)
        compare(cardForTesting.belowMe, slotForTesting)
        compare(cardForTesting.anchors.centerIn, slotForTesting)
        compare(cardForTesting.anchors.verticalCenterOffset, 0)
        compare(cardForTesting.z, slotForTesting.z+1)
        slotForTesting.z++;
        compare(cardForTesting.z, slotForTesting.z+1)
        slotForTesting.aboveMe = null;
        cardForTesting.belowMe = null;
        cardForTesting.anchors.centerIn = undefined;
    }

    function test_anchorCardOverReservedSlot()
    {
        compare(Logic.anchorCardOverSlot(yetAnotherCard, slotForTesting, false), true)
        cardForTesting.anchors.verticalCenterOffset = 101;
        cardForTesting.z = 25;
        compare(Logic.anchorCardOverSlot(cardForTesting, slotForTesting, false), false)
        compare(cardForTesting.belowMe, null)
        compare(cardForTesting.anchors.centerIn, null)
        compare(cardForTesting.anchors.verticalCenterOffset, 101)
        compare(cardForTesting.z, 25)
        slotForTesting.aboveMe = null;
    }

    function test_cardReadyToAnchor_idTooLarge()
    {
        compare(Logic.cardReadyToAnchor(52, false), false)
    }

    function test_cardReadyToAnchor_sameXY()
    {
        Logic.deck[9].x = 400;
        Logic.deck[9].y = 400;
        Logic.deck[23].x = 400;
        Logic.deck[23].y = 400;
        compare(Logic.cardReadyToAnchor(23, false), true)
        Logic.deck[9].aboveMe = null;
        Logic.deck[23].anchors.centerIn = undefined;
    }

    function test_cardReadyToAnchor_sameCardOnlyMatch()
    {
        Logic.deck[23].x = 400;
        Logic.deck[23].y = 400;
        compare(Logic.cardReadyToAnchor(23, false), false)
    }

    function test_cardReadyToAnchor_overFirstCard()
    {
        var xDiff = (Logic.deltaX - Logic.deck[0].width) - 1;
        var yDiff = Logic.cardSeparator-1;
        Logic.deck[0].x = 400;
        Logic.deck[0].y = 400;
        Logic.deck[51].x = Logic.deck[0].x-xDiff+1;
        Logic.deck[51].y = Logic.deck[0].y-yDiff+1;
        compare(Logic.cardReadyToAnchor(51, false), true)
        compare(Logic.deck[51].anchors.centerIn, Logic.deck[0])
        Logic.deck[0].aboveMe = null;
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.deck[51].x = Logic.deck[0].x+xDiff-1;
        Logic.deck[51].y = Logic.deck[0].y+yDiff-1;
        compare(Logic.cardReadyToAnchor(51, false), true)
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
        compare(Logic.cardReadyToAnchor(44, false), true)
        compare(Logic.deck[44].anchors.centerIn, Logic.deck[16])
        compare(Logic.deck[44].anchors.verticalCenterOffset, 30)
    }

    function test_cardReadyToAnchor_notOverAnyCard()
    {
        var xDiff = (Logic.deltaX - Logic.deck[0].width) - 1;
        var yDiff = Logic.cardSeparator-1;
        Logic.deck[13].x = 390;
        Logic.deck[13].y = 390;
        Logic.deck[42].x = 390-xDiff;
        Logic.deck[42].y = 390;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = 390;
        Logic.deck[42].y = 390-yDiff;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].y = 390+yDiff;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = 390+xDiff;
        Logic.deck[42].y = 390;
        compare(Logic.cardReadyToAnchor(42, false), false)
    }

    function test_cardReadyToAnchor_overASlot()
    {
        var xDiff = (Logic.deltaX - Logic.deck[0].width) - 1;
        var yDiff = Logic.cardSeparator-1;
        var slot = Logic.cardSlots[1];
        slot.x = 450;
        slot.y = 450;
        Logic.deck[51].x = 450-xDiff+1;
        Logic.deck[51].y = 450-yDiff+1;
        compare(Logic.cardReadyToAnchor(51, false), true)
        compare(Logic.deck[51].anchors.centerIn, slot)
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.deck[51].x = 450+xDiff-1;
        Logic.deck[51].y = 450+yDiff-1;
        Logic.cardSlots[1].aboveMe = null;
        compare(Logic.cardReadyToAnchor(51, false), true)
        compare(Logic.deck[51].anchors.centerIn, slot)
        compare(Logic.deck[51].anchors.verticalCenterOffset, 0)
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.cardSlots[1].aboveMe = null;
    }

    function test_cardReadyToAnchor_overAnAceSlotInFathersSolitaire()
    {
        var slot = Logic.cardSlots[10];
        slot.x = 450;
        slot.y = 450;
        slot.isAceSlot = true;
        Logic.deck[51].x = 450;
        Logic.deck[51].y = 450;
        Logic.rules = 1; //Father's solitaire
        compare(Logic.cardReadyToAnchor(51, true), false)
        compare(Logic.deck[51].anchors.centerIn, null)
        compare(Logic.cardReadyToAnchor(51, false), true)
        Logic.deck[51].anchors.centerIn = null;
        Logic.cardSlots[10].aboveMe = null;
        Logic.deck[51].x = 0;
        Logic.deck[51].y = 0;
        Logic.deck[0].x = 450;
        Logic.deck[0].y = 450;
        compare(Logic.cardReadyToAnchor(0, true), true)
        compare(Logic.deck[0].anchors.centerIn, slot)
        compare(Logic.deck[0].anchors.verticalCenterOffset, 0)
        Logic.cardSlots[10].aboveMe = null;
        Logic.rules = 0;
    }

    function test_cardReadyToAnchor_overACardOverASlot()
    {
        var slot = Logic.cardSlots[10];
        slot.x = 450;
        slot.y = 450;
        Logic.deck[51].x = 450;
        Logic.deck[51].y = 450;
        compare(Logic.cardReadyToAnchor(51, false), true)
        Logic.deck[49].x = 451;
        Logic.deck[49].y = 451;
        compare(Logic.cardReadyToAnchor(49, false), true)
        compare(Logic.deck[49].anchors.centerIn, Logic.deck[51])
        compare(Logic.deck[49].anchors.verticalCenterOffset, 5)
    }

    function test_cardReadyToAnchor_notOverAnySlot()
    {
        var xDiff = (Logic.deltaX - Logic.deck[0].width) - 1;
        var yDiff = Logic.cardSeparator-1;
        var slot = Logic.cardSlots[10];
        Logic.deck[42].x = slot.x;
        Logic.deck[42].y = slot.y-yDiff;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = slot.x-xDiff;
        Logic.deck[42].y = slot.y;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = slot.x+xDiff;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = slot.x;
        Logic.deck[42].y = slot.y+yDiff;
        compare(Logic.cardReadyToAnchor(42, false), false)
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
        compare(Logic.cardReadyToAnchor(39, false), true)
        compare(Logic.deck[39].anchors.centerIn, Logic.deck[17])
        compare(Logic.deck[39].z, Logic.deck[17].z+1)
    }

    function test_startFathersSolitaire() {
        Logic.startFathersSolitaire();
        compare(Logic.cardSlots[0].aboveMe, Logic.deck[0])
        compare(Logic.cardSlots[6].aboveMe, Logic.deck[45])
        compare(Logic.rules, 1)
    }
}
