import QtQuick 2.2
import QtTest 1.0
import "../application/logic.js" as Logic
import "../application"

TestCase {
    id: mainArea
    name: "LogicTests"
    width: 800
    height: 480
    property int menuButtonWidth: 80

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

    function test_detachCard()
    {
        cardForTesting.aboveMe = cardForMatching;
        cardForMatching.belowMe = cardForTesting;
        cardForTesting.belowMe = yetAnotherCard;
        yetAnotherCard.aboveMe = cardForTesting;
        var cardReturned = Logic.detachCard(cardForTesting);
        compare(cardReturned, cardForTesting);
        compare(cardReturned.aboveMe, null);
        compare(cardReturned.belowMe, null);
        compare(cardForMatching.belowMe, yetAnotherCard);
        compare(yetAnotherCard.aboveMe, cardForMatching);
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
        var xDiff = 54; // half of card width (80/2) + half of (deltaX - cardwidth) ((110-80)/2) - 1.
        var yDiff = 74; // half of card height (120/2) + half of cardSeparator (30/2) - 1.
        Logic.deck[0].x = 400;
        Logic.deck[0].y = 400;
        Logic.deck[0].z = 53;
        Logic.deck[51].x = Logic.deck[0].x-xDiff;
        Logic.deck[51].y = Logic.deck[0].y-yDiff;
        Logic.deck[51].z = 1000;
        compare(Logic.cardReadyToAnchor(51, false), true)
        compare(Logic.deck[51].anchors.centerIn, Logic.deck[0])
        Logic.deck[0].aboveMe = null;
        Logic.deck[51].belowMe = null;
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.deck[51].x = Logic.deck[0].x+xDiff;
        Logic.deck[51].y = Logic.deck[0].y+yDiff;
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
        var xDiff = 54; // half of card width (80/2) + half of (deltaX - cardwidth) ((110-80)/2) - 1.
        var yDiff = 74; // half of card height (120/2) + half of cardSeparator (30/2) - 1.
        Logic.deck[13].x = 390;
        Logic.deck[13].y = 390;
        Logic.deck[42].x = 390-xDiff-1;
        Logic.deck[42].y = 390;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = 390;
        Logic.deck[42].y = 390-yDiff-1;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].y = 390+yDiff+1;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = 390+xDiff+1;
        Logic.deck[42].y = 390;
        compare(Logic.cardReadyToAnchor(42, false), false)
    }

    function test_cardReadyToAnchor_overASlot()
    {
        var xDiff = 54; // half of card width (80/2) + half of (deltaX - cardwidth) ((110-80)/2) - 1.
        var yDiff = 74; // half of card height (120/2) + half of cardSeparator (30/2) - 1.
        var slot = Logic.cardSlots[1];
        slot.x = 450;
        slot.y = 450;
        Logic.deck[51].x = 450-xDiff;
        Logic.deck[51].y = 450-yDiff;
        compare(Logic.cardReadyToAnchor(51, false), true)
        compare(Logic.deck[51].anchors.centerIn, slot)
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.deck[51].x = 450+xDiff;
        Logic.deck[51].y = 450+yDiff;
        Logic.cardSlots[1].aboveMe = null;
        compare(Logic.cardReadyToAnchor(51, false), true)
        compare(Logic.deck[51].anchors.centerIn, slot)
        compare(Logic.deck[51].anchors.verticalCenterOffset, 0)
        Logic.deck[51].anchors.centerIn = undefined;
        Logic.cardSlots[1].aboveMe = null;
    }

    function test_cardReadyToAnchor_overHigherZ()
    {
        Logic.deck[50].x = 450;
        Logic.deck[50].y = 450;
        Logic.deck[50].z = 1000;
        Logic.deck[50].faceDown = false;
        Logic.deck[51].x = 450;
        Logic.deck[51].y = 450;
        Logic.deck[51].z = 1000;
        Logic.deck[51].faceDown = false;
        compare(Logic.cardReadyToAnchor(50, true), false)
        Logic.deck[51].z = 1001;
        compare(Logic.cardReadyToAnchor(50, true), false)
    }

    function test_cardReadyToAnchor_overFaceDownCardInFathersSolitaire()
    {
        Logic.deck[50].x = 450;
        Logic.deck[50].y = 450;
        Logic.deck[50].z = 1000;
        Logic.deck[50].faceDown = false;
        Logic.deck[51].x = 450;
        Logic.deck[51].y = 450;
        Logic.deck[51].z = 45;
        Logic.deck[51].faceDown = true;
        Logic.selectedGame = "fathersSolitaire";
        compare(Logic.cardReadyToAnchor(50, true), false)
        Logic.deck[51].faceDown = false;
        compare(Logic.cardReadyToAnchor(50, true), true)
        Logic.deck[50].anchors.centerIn = null;
        Logic.deck[50].belowMe = null;
        Logic.deck[51].aboveMe = null;
    }

    function test_cardReadyToAnchor_overAnAceSlotInFathersSolitaire()
    {
        var slot = Logic.cardSlots[10];
        slot.x = 450;
        slot.y = 450;
        slot.isAceSlot = true;
        Logic.deck[51].x = 450;
        Logic.deck[51].y = 450;
        Logic.selectedGame = "fathersSolitaire";
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
        Logic.selectedGame = "";
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
        var xDiff = 54; // half of card width (80/2) + half of (deltaX - cardwidth) ((110-80)/2) - 1.
        var yDiff = 74; // half of card height (120/2) + half of cardSeparator (30/2) - 1.
        var slot = Logic.cardSlots[10];
        slot.x = 400;
        slot.y = 400;
        Logic.deck[42].x = slot.x;
        Logic.deck[42].y = slot.y-yDiff-1;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = slot.x-xDiff-1;
        Logic.deck[42].y = slot.y;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = slot.x+xDiff+1;
        compare(Logic.cardReadyToAnchor(42, false), false)
        Logic.deck[42].x = slot.x;
        Logic.deck[42].y = slot.y+yDiff+1;
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
        Logic.startGame("fathersSolitaire");
        compare(Logic.cardSlots[0].aboveMe, Logic.deck[0])
        compare(Logic.deck[0].aboveMe, Logic.deck[7])
        compare(Logic.deck[7].aboveMe, Logic.deck[14])
        compare(Logic.deck[14].aboveMe, Logic.deck[21])
        compare(Logic.deck[21].aboveMe, Logic.deck[28])
        compare(Logic.deck[28].aboveMe, Logic.deck[35])
        compare(Logic.deck[35].aboveMe, Logic.deck[42])
        compare(Logic.deck[42].aboveMe, Logic.deck[49])
        compare(Logic.cardSlots[6].aboveMe, Logic.deck[6])
        compare(Logic.deck[6].aboveMe, Logic.deck[13])
        compare(Logic.deck[13].aboveMe, Logic.deck[20])
        compare(Logic.deck[20].aboveMe, Logic.deck[27])
        compare(Logic.deck[27].aboveMe, Logic.deck[34])
        compare(Logic.deck[34].aboveMe, Logic.deck[41])
        compare(Logic.deck[41].aboveMe, Logic.deck[48])
        compare(Logic.selectedGame, "fathersSolitaire")
        compare(Logic.amountOfRedealsLeft, 3);
    }

    function test_redealFathersSolitaire() {
        Logic.startGame("fathersSolitaire");
        var newLastCardSuite = Logic.deck[49].mySuite;
        var newLastCardNumber = Logic.deck[49].myNumber;
        var lastPileTopCardSuite = Logic.deck[41].mySuite;
        var lastPileTopCardNumber = Logic.deck[41].myNumber;
        Logic.redeal();
        compare(Logic.amountOfRedealsLeft, 2);
        compare(Logic.deck[51].mySuite, newLastCardSuite);
        compare(Logic.deck[51].myNumber, newLastCardNumber);
        compare(Logic.deck[0].mySuite, lastPileTopCardSuite);
        compare(Logic.deck[0].myNumber, lastPileTopCardNumber);
    }

    function test_redealFathersSolitaireWithAceSlots() {
        Logic.selectedGame = "fathersSolitaire";
        Logic.resetDeck();
        Logic.createSlotsForFathersSolitaire();
        compare(Logic.deck[0].mySuite, "diamond");
        compare(Logic.deck[0].myNumber, 1);
        Logic.deck[0].faceDown = false;
        compare(Logic.deck[1].mySuite, "diamond");
        compare(Logic.deck[1].myNumber, 2);
        Logic.deck[1].faceDown = false;
        compare(Logic.deck[2].mySuite, "diamond");
        compare(Logic.deck[2].myNumber, 3);
        Logic.deck[2].faceDown = false;
        compare(Logic.anchorCardOverSlot(Logic.deck[0], Logic.cardSlots[7], true), true);
        compare(Logic.anchorCardOverOther(Logic.deck[1], Logic.deck[0], true), true);
        compare(Logic.anchorCardOverOther(Logic.deck[2], Logic.deck[1], true), true);
        Logic.cardsToBypassWhenDealing = 3;
        Logic.dealFathersSolitaire();
        Logic.cardsToBypassWhenDealing = 0;
        Logic.amountOfRedealsLeft = 0;
        Logic.redeal();
        compare(Logic.amountOfRedealsLeft, 0);
        compare(Logic.deck[0].mySuite, "diamond");
        compare(Logic.deck[0].myNumber, 1);
        Logic.amountOfRedealsLeft = 1;
        Logic.redeal();
        compare(Logic.cardsToBypassWhenDealing, 3);
        compare(Logic.deck[0].mySuite, "diamond");
        compare(Logic.deck[0].myNumber, 3);
        compare(Logic.deck[1].mySuite, "diamond");
        compare(Logic.deck[1].myNumber, 2);
        compare(Logic.deck[2].mySuite, "diamond");
        compare(Logic.deck[2].myNumber, 1);
    }

    function test_initialSlotsEmptyForFathersSolitaire() {
        Logic.selectedGame = "fathersSolitaire";
        Logic.resetDeck();
        Logic.createSlotsForFathersSolitaire();
        compare(Logic.initialSlotsEmpty(), true);
        compare(Logic.anchorCardOverSlot(Logic.deck[0], Logic.cardSlots[7], true), true);
        compare(Logic.initialSlotsEmpty(), true);
        compare(Logic.anchorCardOverSlot(Logic.deck[13], Logic.cardSlots[8], true), true);
        compare(Logic.initialSlotsEmpty(), true);
        compare(Logic.anchorCardOverSlot(Logic.deck[26], Logic.cardSlots[9], true), true);
        compare(Logic.initialSlotsEmpty(), true);
        compare(Logic.anchorCardOverSlot(Logic.deck[39], Logic.cardSlots[10], true), true);
        compare(Logic.initialSlotsEmpty(), true);
        compare(Logic.anchorCardOverSlot(Logic.deck[1], Logic.cardSlots[0], true), true);
        compare(Logic.initialSlotsEmpty(), false);
        Logic.cardSlots[0].aboveMe = null;
        Logic.deck[1].belowMe = null;
        Logic.deck[1].anchors.centerIn = undefined;
        compare(Logic.anchorCardOverSlot(Logic.deck[1], Logic.cardSlots[1], true), true);
        compare(Logic.initialSlotsEmpty(), false);
        Logic.cardSlots[1].aboveMe = null;
        Logic.deck[1].belowMe = null;
        Logic.deck[1].anchors.centerIn = undefined;
        compare(Logic.anchorCardOverSlot(Logic.deck[1], Logic.cardSlots[2], true), true);
        compare(Logic.initialSlotsEmpty(), false);
        Logic.cardSlots[2].aboveMe = null;
        Logic.deck[1].belowMe = null;
        Logic.deck[1].anchors.centerIn = undefined;
        compare(Logic.anchorCardOverSlot(Logic.deck[1], Logic.cardSlots[3], true), true);
        compare(Logic.initialSlotsEmpty(), false);
        Logic.cardSlots[3].aboveMe = null;
        Logic.deck[1].belowMe = null;
        Logic.deck[1].anchors.centerIn = undefined;
        compare(Logic.anchorCardOverSlot(Logic.deck[1], Logic.cardSlots[4], true), true);
        compare(Logic.initialSlotsEmpty(), false);
        Logic.cardSlots[4].aboveMe = null;
        Logic.deck[1].belowMe = null;
        Logic.deck[1].anchors.centerIn = undefined;
        compare(Logic.anchorCardOverSlot(Logic.deck[1], Logic.cardSlots[5], true), true);
        compare(Logic.initialSlotsEmpty(), false);
        Logic.cardSlots[5].aboveMe = null;
        Logic.deck[1].belowMe = null;
        Logic.deck[1].anchors.centerIn = undefined;
        compare(Logic.anchorCardOverSlot(Logic.deck[1], Logic.cardSlots[6], true), true);
        compare(Logic.initialSlotsEmpty(), false);
        Logic.cardSlots[6].aboveMe = null;
        Logic.deck[1].belowMe = null;
        Logic.deck[1].anchors.centerIn = undefined;
    }
}
