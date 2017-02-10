var deck = new Array(52);
var cardSlots = new Array(13);
var slotCount = 0;
var firstRowY = 5;
var firstGameAreaRowY = 150;
var firstColumnX = 30;
var deltaX = 110; // card width (80) + card separator (30).
var deltaY = 150; // card height (120) + card separator (30).
var allowedCardOffsetX = 54; // half of card width (80/2) + half of (deltaX - cardwidth) ((110-80)/2) - 1.
var allowedCardOffsetY = 74; // half of card height (120/2) + half of card separator (30/2) - 1.
var selectedGame = "none";
var cardsToBypassWhenDealing = 0;
var amountOfRedealsLeft = -1;

function startGame(gameId) {
    selectedGame = gameId;
    resetDeck();
    if ("fathersSolitaire" === selectedGame)
    {
        amountOfRedealsLeft = 3;
        mainObject.shuffleButtonVisible = true;
        mainObject.shuffleButtonActive = true;
        shuffleDeck();
        createSlotsForFathersSolitaire();
        dealFathersSolitaire();
        mainObject.gameAreaHeight = 1000;
        return true;
    }
    else if ("napoleon" === selectedGame)
    {
        amountOfRedealsLeft = 0;
        mainObject.shuffleButtonVisible = false;
        mainObject.shuffleButtonActive = false;
        shuffleDeck();
        createSlotsForNapoleonsGrave();
        dealNapoleonsGrave();
        mainObject.gameAreaHeight = mainWindow.height;
        return true;
    }
    else if ("blackRed" === selectedGame)
    {
        amountOfRedealsLeft = 3;
        mainObject.shuffleButtonActive = false;
        mainObject.shuffleButtonVisible = true;
        shuffleDeck();
        createSlotsForBlackRed();
        dealBlackRed();
        mainObject.gameAreaHeight = 700;
        return true;
    }

    return false;
}

function redeal()
{
    if( mainObject.shuffleButtonActive &&
        amountOfRedealsLeft )
    {
        amountOfRedealsLeft--;
        if( "fathersSolitaire" === selectedGame )
        {
            reDealFathersSolitaire();
        }
        else if ("blackRed" === selectedGame)
        {
            reDealBlackRedSolitaire();
        }
        else
        {
            console.log("Attempt to redeal in game without redeal functionality!");
        }
    }
    if( 0 === amountOfRedealsLeft )
    {
        mainObject.shuffleButtonActive = false;
    }
}

function reDealBlackRedSolitaire()
{
    // Pick cards from slot 12 and pile them face down to slot 11 in opposite order.
    var source = cardSlots[12];
    while (source.aboveMe)
        source = source.aboveMe;
    // anchor card(s) in reverse order, face down.
    var cardToPlace = source;
    var target = cardSlots[11];
    while (cardToPlace.belowMe) {
        source = cardToPlace.belowMe;
        detachCard(cardToPlace);
        cardToPlace.faceDown = true;
        if (target.belowMe) {
            anchorCardOverOther(cardToPlace, target, false);
        } else {
            anchorCardOverSlot(cardToPlace, target, false);
        }
        target = cardToPlace;
        cardToPlace = source;
    }
    mainObject.shuffleButtonActive = false;
}

function reDealFathersSolitaire()
{
    var deckIndex = 51;
    var slotIndex;
    for( slotIndex = 0 ; slotIndex < 7 ; slotIndex++ )
    {
        if( cardSlots[slotIndex].aboveMe )
        {
            var faceUpCardPtr = cardSlots[slotIndex].aboveMe;
            while( faceUpCardPtr.aboveMe )
            {
                faceUpCardPtr = faceUpCardPtr.aboveMe;
            }
            // Now on topmost card
            while( faceUpCardPtr.belowMe &&
                   (!faceUpCardPtr.faceDown) )
            {
                var cardToDetach = faceUpCardPtr;
                faceUpCardPtr = faceUpCardPtr.belowMe;
                deck[deckIndex] = detachCard(cardToDetach);
                deck[deckIndex].faceDown = true;
                deckIndex--;
            }
            // Now either on slot or on topmost face-down card.
        }
    }
    // All face-up cards have been collected.
    for( slotIndex = 0 ; slotIndex < 7 ; slotIndex++ )
    {
        var faceDownCardPtr = cardSlots[slotIndex].aboveMe;
        while( faceDownCardPtr )
        {
            var faceDownCardToDetach = faceDownCardPtr;
            faceDownCardPtr = faceDownCardPtr.aboveMe;
            deck[deckIndex] = detachCard(faceDownCardToDetach);
            deckIndex--;
        }
    }
    // deckIndex should be at -1 if all cards were gathered to deck.
    cardsToBypassWhenDealing = deckIndex+1;
    if( cardsToBypassWhenDealing )
    {
        //some cards were placed on ace slots already
        for( slotIndex = 0 ; slotIndex < 4 ; slotIndex++ )
        {
            var aceSlotCardPtr = cardSlots[7+slotIndex].aboveMe;
            while( aceSlotCardPtr &&
                   (deckIndex >= 0) )
            {
                deck[deckIndex] = aceSlotCardPtr;
                aceSlotCardPtr = aceSlotCardPtr.aboveMe;
                deckIndex--;
            }
        }
    }
    for( var newDeckIndex = 0 ; newDeckIndex < 52 ; newDeckIndex++ )
    {
        deck[newDeckIndex].myId = newDeckIndex;
    }
    dealFathersSolitaire();
}

function detachCard(cardToDetach)
{
    if( cardToDetach.aboveMe )
    {
        cardToDetach.aboveMe.belowMe = cardToDetach.belowMe;
    }
    if( cardToDetach.belowMe )
    {
        cardToDetach.belowMe.aboveMe = cardToDetach.aboveMe;
    }
    resetCard(cardToDetach);
    return cardToDetach;
}

function indexOfSixWithinTopTenCards()
{
    for( var index = 51 ; index > 41 ; index-- )
    {
        if( 6 === deck[index].myNumber )
        {
            return index;
        }
    }
    return -1;
}

function dealFathersSolitaire() {
    var index = cardsToBypassWhenDealing;
    for( var round = 0 ; (round < 8) && (index < 52) ; round++ )
    {
        for( var column = 0 ; (column < 7) && (index < 52) ; column++ )
        {
            if( round >= column )
            {
                deck[index].faceDown = false;
            }
            if( round > 0 )
            {
                anchorCardOverOther(deck[index], deck[index-7], false);
            }
            else
            {
                anchorCardOverSlot(deck[index], cardSlots[column], false);
            }
            index++;
        }
    }
}

function dealNapoleonsGrave() {
    // shuffle the deck until there is a six within top ten cards
    var indexOfSix = indexOfSixWithinTopTenCards();
    while( -1 === indexOfSix ) {
        shuffleDeck();
        indexOfSix = indexOfSixWithinTopTenCards();
    }
    // Entire deck to deck slot, except from six onwards
    anchorCardOverSlot(deck[0], cardSlots[0], false);
    for( var index = 1 ; index < indexOfSix ; index++ )
    {
        anchorCardOverOther(deck[index], deck[index-1], false);
    }
    deck[index-1].faceDown=false;
    // six to six slot
    anchorCardOverSlot(deck[indexOfSix], cardSlots[11], false);
    deck[indexOfSix].faceDown=false;
    if( 51 > indexOfSix )
    {
        // rest of cards to turned over slot
        anchorCardOverSlot(deck[indexOfSix+1], cardSlots[1], false);
        deck[indexOfSix+1].faceDown=false;
        for( index = indexOfSix+2 ; index < 52 ; index++ )
        {
            anchorCardOverOther(deck[index], deck[index-1], false);
            deck[index].faceDown=false;
        }
    }
}

function dealBlackRed() {
    var index = 0;
    for( var start = 0; start < 7; start++ )
    {
        for( var column = start; column < 7; column++ )
        {
            if( start == column )
            {
                deck[index].faceDown = false;
            }
            if( start > 0 )
            {
                anchorCardOverOther(deck[index], deck[index-(7-start)], false);
            }
            else
            {
                anchorCardOverSlot(deck[index], cardSlots[column], false);
            }
            index++;
        }
    }
    // rest of the deck to start pile.
    anchorCardOverSlot(deck[index], cardSlots[11], false);
    index++;
    while (index < 52) {
        anchorCardOverOther(deck[index], deck[index-1], false);
        deck[index].anchors.verticalCenterOffset = 0
        index++;
    }
}

function gameIsComplete() {
    if( "fathersSolitaire" === selectedGame )
    {
        if( cardSlots[0].aboveMe ||
            cardSlots[1].aboveMe ||
            cardSlots[2].aboveMe ||
            cardSlots[3].aboveMe ||
            cardSlots[4].aboveMe ||
            cardSlots[5].aboveMe ||
            cardSlots[6].aboveMe )
            return false;
        else
            return true;
    }
    else if( "napoleon" === selectedGame )
    {
        if( cardSlots[0].aboveMe ||
            cardSlots[1].aboveMe ||
            cardSlots[3].aboveMe ||
            cardSlots[5].aboveMe ||
            cardSlots[7].aboveMe ||
            cardSlots[9].aboveMe )
            return false;
        else
            return true;
    }
    else if ("blackRed" === selectedGame)
    {
        if( cardSlots[0].aboveMe ||
            cardSlots[1].aboveMe ||
            cardSlots[2].aboveMe ||
            cardSlots[3].aboveMe ||
            cardSlots[4].aboveMe ||
            cardSlots[5].aboveMe ||
            cardSlots[6].aboveMe ||
            cardSlots[11].aboveMe ||
            cardSlots[12].aboveMe )
            return false;
        else
            return true;
    }
    console.log("Attempt to check gameIsComplete in game without that functionality!");
    return false;
}

function createDeck() {
    var component = Qt.createComponent("Card.qml");
    if (component.status === Component.Ready)
    {
        for( var suite = 0 ; suite < 4 ; suite++ ) {
            for( var number = 0 ; number < 13 ; number++ ) {
                createCard(component, suite, number);
            }
        }
        resetDeck();
    }
    else if (component.status === Component.Error) {
        console.log("Error: ");
        console.log(component.errorString() );
    }
}

function createCard(component, suite, number)
{
    var suiteText = "spade"
    switch( suite )
    {
    case 0:
        suiteText = "diamond";
        break;
    case 1:
        suiteText = "clubs";
        break;
    case 2:
        suiteText = "heart";
        break;
    default:
        break;
    }

    var newObject = component.createObject(mainObject);
    newObject.myNumber = number+1;
    newObject.mySuite = suiteText;
    newObject.myId = toIndex(suite,number);
    deck[newObject.myId] = newObject;
}

function resetCard(cardToReset)
{
    cardToReset.aboveMe = null;
    cardToReset.belowMe = null;
    cardToReset.anchors.centerIn = null;
    cardToReset.x = firstColumnX;
    cardToReset.y = firstRowY;
    cardToReset.z = 10+cardToReset.myId;
    cardToReset.faceDown = true;
}

function resetDeck()
{
    cardsToBypassWhenDealing = 0;
    for( var index = 0 ; index < 52 ; index++ ) {
        resetCard(deck[index]);
    }
}

function shuffleDeck()
{
    for( var index = 0 ; index < 52 ; index++ ) {
        var cardToMove = deck[index];
        var newIndex = Math.floor(Math.random()*52);
        deck[index] = deck[newIndex];
        deck[newIndex] = cardToMove;
    }
    for( var index = 0 ; index < 52 ; index++ ) {
        deck[index].z = 10+index;
        deck[index].myId = index;
    }
}

function deleteSlots()
{
    for( var index = 0 ; index < slotCount ; index++ )
    {
        cardSlots[index].destroy();
        cardSlots[index] = null;
    }
    slotCount = 0;
}

function createSlots(count)
{
    var component = Qt.createComponent("CardSlot.qml");
    if (component.status === Component.Ready)
    {
        for( var index = 0 ; index < count ; index++ ) {
            cardSlots[index] = component.createObject(mainObject);
        }
        slotCount = count;
    }
    else if (component.status === Component.Error) {
        console.log("Error: ");
        console.log(component.errorString() );
    }
}

function createSlotsForFathersSolitaire()
{
    createSlots(11);
    if( slotCount === 11 )
    {
        for( var index = 0 ; index < 7 ; index++ ) {
            cardSlots[index].x = firstColumnX + (index * deltaX);
            cardSlots[index].y = firstGameAreaRowY;
            cardSlots[index].z = 1;
        }
        for( index = 0 ; index < 4 ; index++ ) {
            cardSlots[index+7].x = firstColumnX + (index * deltaX);
            cardSlots[index+7].y = firstRowY;
            cardSlots[index+7].z = 1;
            cardSlots[index+7].acceptsOnlySpecificNumber = true;
            cardSlots[index+7].acceptedNumber = 1;
            cardSlots[index+7].faceUpVerticalOffset = 0;
        }
    }
}

function createSlotsForNapoleonsGrave()
{
    createSlots(12);
    if( slotCount === 12 )
    {
        // slot for deck
        cardSlots[0].x = firstColumnX;
        cardSlots[0].y = firstRowY;
        cardSlots[0].z = 1;
        // slot for turned over cards
        cardSlots[1].x = firstColumnX;
        cardSlots[1].y = firstRowY + deltaY;
        cardSlots[1].z = 1;
        for( var row = 0 ; row < 3 ; row++ ) {
            for( var column = 0 ; column < 3 ; column++ ) {
                var index = 2 + (row*3) + column;
                cardSlots[index].x = firstColumnX + ((column+1) * deltaX) + (deltaX / 2);
                cardSlots[index].y = firstRowY + (row * deltaY);
                cardSlots[index].z = 1;
            }
        }
        // slots for sevens
        cardSlots[2].acceptsOnlySpecificNumber = true;
        cardSlots[2].acceptedNumber = 7;
        cardSlots[4].acceptsOnlySpecificNumber = true;
        cardSlots[4].acceptedNumber = 7;
        cardSlots[8].acceptsOnlySpecificNumber = true;
        cardSlots[8].acceptedNumber = 7;
        cardSlots[10].acceptsOnlySpecificNumber = true;
        cardSlots[10].acceptedNumber = 7;
        // slots for sixes
        cardSlots[11].x = firstColumnX + (5 * deltaX);
        cardSlots[11].y = firstRowY;
        cardSlots[11].z = 1;
        cardSlots[11].acceptsOnlySpecificNumber = true;
        cardSlots[11].acceptedNumber = 6;
        cardSlots[6].acceptsOnlySpecificNumber = true;
        cardSlots[6].acceptedNumber = 6;
        for( index = 0; index < 12; ++index) {
            cardSlots[index].faceUpVerticalOffset = 0;
            cardSlots[index].faceDownVerticalOffset = 0;
        }
    }
}

function createSlotsForBlackRed()
{
    createSlots(13);
    if( slotCount === 13 )
    {
        for( var index = 0 ; index < 7 ; index++ ) {
            cardSlots[index].x = firstColumnX + (index * deltaX);
            cardSlots[index].y = firstGameAreaRowY;
            cardSlots[index].z = 1;
        }
        for( index = 0 ; index < 4 ; index++ ) {
            cardSlots[index+7].x = firstColumnX + ((index+3) * deltaX);
            cardSlots[index+7].y = firstRowY;
            cardSlots[index+7].z = 1;
            cardSlots[index+7].acceptsOnlySpecificNumber = true;
            cardSlots[index+7].acceptedNumber = 1;
            cardSlots[index+7].faceUpVerticalOffset = 0;
        }
        for( index = 0 ; index < 2 ; index++ ) {
            cardSlots[index+11].x = firstColumnX + (index * deltaX);
            cardSlots[index+11].y = firstRowY;
            cardSlots[index+11].z = 1;
            cardSlots[index+11].faceUpVerticalOffset = 0;
            cardSlots[index+11].faceDownVerticalOffset = 0;
        }
    }
}

function toIndex(suite, number)
{
    return number + (suite*13);
}

function rulesAllowCardOverSlot(cardInQuestion, slotToUse)
{
    if( slotToUse.acceptsOnlySpecificNumber &&
        (cardInQuestion.myNumber !== slotToUse.acceptedNumber) )
        return false; // None of the rules allow this.

    if( selectedGame === "fathersSolitaire" )
    {
        // Aceslot only accepts ace that is not part of a pile.
        if( slotToUse.acceptsOnlySpecificNumber )
        {
            // card already matches to slot or we wouldn't be here
            if( cardInQuestion.aboveMe === null )
                return true;
            else
                return false;
        }
        // allows any card over empty slot when it's not ace slot
        return true;
    }
    else if (selectedGame === "napoleon")
    {
        // Cards cannot be put back to original slot.
        if (slotToUse === cardSlots[0])
            return false;
        else // Everything else is fine if original check was passed.
            return true;
    }
    else if ("blackRed" === selectedGame)
    {
        // Player cannot place a card over pile slots.
        if( (slotToUse === cardSlots[11]) ||
            (slotToUse === cardSlots[12]) )
            return false;
        // Aceslot only accepts ace that is not part of a pile.
        if( slotToUse.acceptsOnlySpecificNumber )
        {
            // card already matches to slot or we wouldn't be here
            if( cardInQuestion.aboveMe === null )
                return true;
            else
                return false;
        }
        // allows any card over empty slot when it's not ace slot
        return true;
    }
    else
    {
        console.log("No game selected when using rules to place card!")
        //No rules, everything allowed
        return true;
    }
}

function anchorCardOverSlot(cardToAnchor, slotToUse, applyRuling)
{
    if( (slotToUse.aboveMe === null) )
    {
        if( !applyRuling ||
            rulesAllowCardOverSlot(cardToAnchor, slotToUse) )
        {
            slotToUse.aboveMe = cardToAnchor;
            cardToAnchor.belowMe = slotToUse;
            cardToAnchor.anchors.centerIn = slotToUse;
            cardToAnchor.anchors.verticalCenterOffset = 0;
            cardToAnchor.z = Qt.binding(function() {return slotToUse.z+1});
            return true;
        }
    }
    return false;
}

function getSlotBelowCard(cardObject)
{
    var slot = cardObject.belowMe;
    while( slot &&
           (slot.belowMe !== undefined) &&
           (slot.belowMe !== null) )
    {
        slot = slot.belowMe;
    }
    return slot;
}

function cardIsOverAceSlot(cardObject)
{
    var slot = getSlotBelowCard(cardObject);
    if( slot &&
        slot.acceptsOnlySpecificNumber  &&
        (1 === slot.acceptedNumber) )
        return true;
    else
        return false;
}

function cardIsRed(cardToCheck)
{
    if ((cardToCheck.mySuite === "heart") ||
        (cardToCheck.mySuite === "diamond"))
        return true;
    else
        return false;
}

function cardsAreBlackAndRed(cardBelow, cardOnTop)
{
    if ( cardIsRed(cardBelow) &&
        !cardIsRed(cardOnTop) )
            return true;
    if(!cardIsRed(cardBelow) &&
        cardIsRed(cardOnTop) )
            return true;
    return false;
}

function rulesAllowCardOverOther(cardOnTop, cardBelow)
{
    var slot = getSlotBelowCard(cardBelow);
    if( selectedGame == "fathersSolitaire" )
    {
        if( cardBelow.faceDown )
            return false; // Never OK to be over face down card
        if( cardIsOverAceSlot(cardBelow) )
        {
            // Card needs to be of same suite and one larger than the one below
            if( (cardBelow.mySuite === cardOnTop.mySuite) &&
                ((cardBelow.myNumber+1) === cardOnTop.myNumber) )
            {
                // Card needs to be alone
                if( cardOnTop.aboveMe === null )
                    return true;
            }
            return false;
        }
        // Card needs to be of same suite and one smaller than the one below
        if( (cardBelow.mySuite === cardOnTop.mySuite) &&
            (cardBelow.myNumber === (cardOnTop.myNumber+1)) )
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else if (selectedGame == "napoleon")
    {
        // can always pile to turnover slot
        if( cardSlots[1] === slot)
            return true;
        //only sixes allowed to six slot
        if( cardSlots[11] === slot) {
            if (cardOnTop.myNumber === 6)
                return true;
            else
                return false;
        }
        if (slot.acceptsOnlySpecificNumber) {
            // has to be one number greater if seven slot and one number fewer in center slot
            if (7 === slot.acceptedNumber) {
                if( cardOnTop.myNumber === (cardBelow.myNumber + 1) )
                    return true;
                else
                    return false;
            } else {
                if( (cardOnTop.myNumber + 1) === cardBelow.myNumber ) {
                    return true;
                } else {
                    // six can be placed on top of ace
                    if( (6 === cardOnTop.myNumber) &&
                        (1 === cardBelow.myNumber)) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
        // only one card on generic slots.
        return false;
    }
    else if ("blackRed" === selectedGame)
    {
        // Never OK to be over face down card
        if( cardBelow.faceDown )
            return false;
        // Cannot be placed to either pile.
        if ( (cardSlots[11] === slot) ||
             (cardSlots[12] === slot) )
            return false;
        // Ace slot
        if( slot.acceptsOnlySpecificNumber )
        {
            // Card needs to be of same suite and one larger than the one below
            if( (cardBelow.mySuite === cardOnTop.mySuite) &&
                ((cardBelow.myNumber+1) === cardOnTop.myNumber) )
            {
                // Card needs to be alone
                if( cardOnTop.aboveMe === null )
                    return true;
            }
            return false;
        }
        // Elsewhere card needs to be of suite of opposite color and one smaller than the one below
        if( (cardBelow.myNumber === (cardOnTop.myNumber+1)) &&
            cardsAreBlackAndRed(cardBelow, cardOnTop) )
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        console.log("No rules defined when placing card over another!");
        return true;
    }
}

function getVerticalOffsetForCard(cardObject)
{
    var slot = getSlotBelowCard(cardObject);
    if (cardObject.faceDown)
        return slot.faceDownVerticalOffset;
    else
        return slot.faceUpVerticalOffset;
}

function anchorCardOverOther(cardOnTop, cardBelow, applyRuling)
{
    if(cardBelow !== undefined)
    {
        if( (cardOnTop !== cardBelow) &&
            (cardBelow.aboveMe === null) )
        {
            if( !applyRuling ||
                rulesAllowCardOverOther(cardOnTop, cardBelow) )
            {
                cardOnTop.anchors.centerIn = cardBelow;
                cardOnTop.anchors.verticalCenterOffset = getVerticalOffsetForCard(cardBelow);
                cardOnTop.z = Qt.binding(function() {return cardBelow.z+1});
                cardBelow.aboveMe = cardOnTop;
                cardOnTop.belowMe = cardBelow;
                return true;
            }
        }
    }
    return false;
}

function cardReadyToAnchor(cardIndex, applyRuling)
{
    if( !(52 > cardIndex) )
    {
        console.log("Invalid card index ", cardIndex, " tried to be attached, aborting...");
        return false;
    }

    var cardToAnchor = deck[cardIndex];
    var selectedCard;
    var isSlot = false;
    for( var slotLoopIndex = 0 ; slotLoopIndex < slotCount ; slotLoopIndex++ )
    {
        // First try card slots
        var compareSlot = cardSlots[slotLoopIndex];
        if( ((compareSlot.x-allowedCardOffsetX) <= cardToAnchor.x) &&
             (cardToAnchor.x <= (compareSlot.x + allowedCardOffsetX)) &&
            ((compareSlot.y-allowedCardOffsetY) <= cardToAnchor.y) &&
             (cardToAnchor.y <= (compareSlot.y + allowedCardOffsetY)) )
        {
            selectedCard = compareSlot;
            isSlot = true;
        }
    }

    for( var cardLoopIndex = 0 ; cardLoopIndex < 52 ; cardLoopIndex++ )
    {
        var compareCard = deck[cardLoopIndex];
        // Check for same card anchoring to avoid loop reference
        if( (compareCard.z < cardToAnchor.z) &&
            ((compareCard.x-allowedCardOffsetX) <= cardToAnchor.x) &&
            (cardToAnchor.x <= (compareCard.x + allowedCardOffsetX)) &&
            ((compareCard.y-allowedCardOffsetY) <= cardToAnchor.y) &&
            (cardToAnchor.y <= (compareCard.y + allowedCardOffsetY)) )
        {
            if( selectedCard === undefined )
            {
                selectedCard = compareCard;
            }
            else
            {
                if( isSlot ||
                    (compareCard.z > selectedCard.z) )
                {
                    selectedCard = compareCard;
                }
            }
            isSlot = false;
        }
    }
    var returnValue;
    if( isSlot )
    {
        returnValue = anchorCardOverSlot(cardToAnchor, selectedCard, applyRuling);
    }
    else
    {
        returnValue = anchorCardOverOther(cardToAnchor, selectedCard, applyRuling);
    }
    if( false === returnValue )
    {
        // Anchoring failed, make sure card is left without connections.
        if( cardToAnchor.belowMe )
        {
            cardToAnchor.belowMe.aboveMe = null;
            cardToAnchor.belowMe = null;
        }
        cardToAnchor.anchors.centerIn = null;
    }
    return returnValue;
}

function facedownCardClickAction(cardIndex)
{
    if (52 > cardIndex) {
        var cardForAction = deck[cardIndex];
        var slot = getSlotBelowCard(cardForAction);
        if ("blackRed" === selectedGame) {
            if (cardSlots[11] === slot) {
                // Take third card from the top
                var cardToDetach = cardForAction;
                for (var loop = 0; loop < 2; loop++) {
                    if (cardToDetach.belowMe.belowMe)
                        cardToDetach = cardToDetach.belowMe;
                }
                // Detach card(s) from pile
                cardToDetach.belowMe.aboveMe = null;
                cardToDetach.belowMe = null;
                cardToDetach.anchors.centerIn = null;
                // find top card of turnover pile (or slot itself)
                var target = cardSlots[12];
                while (target.aboveMe)
                    target = target.aboveMe;
                // anchor card(s) in reverse order, face up.
                while (cardForAction) {
                    cardToDetach = cardForAction;
                    cardForAction = cardToDetach.belowMe;
                    detachCard(cardToDetach);
                    cardToDetach.faceDown = false;
                    if (target.belowMe) {
                        anchorCardOverOther(cardToDetach, target, false);
                    } else {
                        anchorCardOverSlot(cardToDetach, target, false);
                    }
                    target = cardToDetach;
                }
                if( null === cardSlots[11].aboveMe )
                    mainObject.shuffleButtonActive = true;
                return true;
            }
        }
        // For everything else, no-op.
    } else {
        console.log("Invalid card index ", cardIndex, " tried to perform card click action, aborting...");
    }
    return false;
}
