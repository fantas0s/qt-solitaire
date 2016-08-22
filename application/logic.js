var deck = new Array(52);
var cardSlots = new Array(11);
var slotCount = 0;
var cardSeparator = 30;
var faceDownCardSeparator = 5;
var firstRowY = 5;
var firstGameAreaRowY = 150;
var firstColumnX = 30;
var deltaX = 110;
var cardSpacing = 31;
var rules = 0;

function startFathersSolitaire() {
    resetDeck();
    shuffleDeck();
    createSlotsForFathersSolitaire();
    rules = 1;
    dealFathersSolitaire();
}

function dealFathersSolitaire() {
    var index = 0;
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

function resetDeck()
{
    for( var index = 0 ; index < 52 ; index++ ) {
        var cardToReset = deck[index];
        cardToReset.x = firstColumnX;
        cardToReset.y = firstRowY;
        cardToReset.z = 10+index;
        cardToReset.aboveMe = null;
        cardToReset.belowMe = null;
        cardToReset.anchors.centerIn = null;
        cardToReset.faceDown = true;
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
            cardSlots[index+7].z = 54;
            cardSlots[index+7].isAceSlot = true;
        }
    }
}

function toIndex(suite, number)
{
    return number + (suite*13);
}

function rulesAllowCardOverSlot(cardInQuestion, slotToUse)
{
    switch( rules )
    {
    case 1: //Father's solitaire
        {
            // Ace can be only over ace slot
            if( slotToUse.isAceSlot )
            {
                if(cardInQuestion.myNumber === 1)
                {
                    // and it must be alone
                    if( cardInQuestion.aboveMe === null )
                        return true;
                }
                return false;
            }
            // allows any card over empty slot when it's not ace slot
            return true;
        }
    default: //No rules, everything allowed
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

function cardIsOverAceSlot(cardObject)
{
    var slot = cardObject.belowMe;
    while( slot &&
           (slot.belowMe !== undefined) &&
           (slot.belowMe !== null) )
    {
        slot = slot.belowMe;
    }
    if( slot &&
        slot.isAceSlot )
        return true;
    else
        return false;
}

function rulesAllowCardOverOther(cardOnTop, cardBelow)
{
    switch( rules )
    {
    case 1: //Father's solitaire
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
                return true;
            else
                return false;
        }
    default: //No rules, everything allowed
        return true;
    }
}

function getDefaultOffset(cardBelow)
{
    // Default pileup
    if( cardBelow.faceDown )
        return faceDownCardSeparator;
    else
        return cardSeparator;
}

function offsetFromRuling(cardBelow)
{
    switch( rules )
    {
    case 1: //Father's solitaire
        {
        if( cardIsOverAceSlot(cardBelow) )
            return 0;
        else
            return getDefaultOffset(cardBelow);
        }
    default:
        return getDefaultOffset(cardBelow);
    }
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
                if( applyRuling )
                    cardOnTop.anchors.verticalCenterOffset = offsetFromRuling(cardBelow);
                else
                    cardOnTop.anchors.verticalCenterOffset = getDefaultOffset(cardBelow);
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
        return false;
    }

    var cardToAnchor = deck[cardIndex];
    var selectedCard;
    var isSlot = false;
    for( var slotLoopIndex = 0 ; slotLoopIndex < 11 ; slotLoopIndex++ )
    {
        // First try card slots
        var compareSlot = cardSlots[slotLoopIndex];
        if( ((compareSlot.x-cardSpacing) < cardToAnchor.x) &&
            (cardToAnchor.x < (compareSlot.x + cardSpacing)) &&
            ((compareSlot.y-cardSpacing) < cardToAnchor.y) &&
            (cardToAnchor.y < (compareSlot.y + cardSpacing)) )
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
            ((compareCard.x-cardSpacing) < cardToAnchor.x) &&
            (cardToAnchor.x < (compareCard.x + cardSpacing)) &&
            ((compareCard.y-cardSpacing) < cardToAnchor.y) &&
            (cardToAnchor.y < (compareCard.y + cardSpacing)) )
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
    if( isSlot )
    {
        return anchorCardOverSlot(cardToAnchor, selectedCard, applyRuling);
    }
    else
    {
        return anchorCardOverOther(cardToAnchor, selectedCard, applyRuling);
    }
}
