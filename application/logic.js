var deck = new Array(52);
var cardSlots = new Array(11);
var cardSeparator = 30;
var faceDownCardSeparator = 5;
var firstRowY = 5;
var firstGameAreaRowY = 150;
var firstColumnX = 30;
var deltaX = 110;

function startFreeRange() {
    createDeck();
    shuffleDeck();
    createSlotsForFreeRange();
    var index = 0;
    var xOrigin = firstColumnX;

    for( var column = 0 ; (column < 7) && (index < 52) ; column++ )
    {
        var yOrigin = firstGameAreaRowY;
        for( var round = 0 ; ((round < 7) || ((column < 3) && (round < 8))) && (index < 52) ; round++ )
        {
            if( round > column )
            {
                anchorCardOverOther(deck[index], deck[index-1], cardSeparator);
            }
            else
            {
                deck[index].x = xOrigin;
                deck[index].y = yOrigin;
                deck[index].z = deck[index].y;
                yOrigin += faceDownCardSeparator;
            }
            if( round >= column )
            {
                deck[index].faceDown = false;
            }
            index++;
        }
        xOrigin += deltaX;
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
    newObject.x = firstColumnX;
    newObject.y = firstRowY;
    newObject.myNumber = number+1;
    newObject.mySuite = suiteText;
    newObject.myId = toIndex(suite,number);
    deck[newObject.myId] = newObject;
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

function createSlotsForFreeRange()
{
    var component = Qt.createComponent("CardSlot.qml");
    if (component.status === Component.Ready)
    {
        for( var index = 0 ; index < 7 ; index++ ) {
            var newObject = component.createObject(mainObject);
            newObject.x = firstColumnX + (index * deltaX);
            newObject.y = firstGameAreaRowY;
            cardSlots[index] = newObject;
        }
        for( index = 0 ; index < 4 ; index++ ) {
            newObject = component.createObject(mainObject);
            newObject.x = firstColumnX + (index * deltaX);
            newObject.y = firstRowY;
            newObject.aceMarkerVisible = true;
            cardSlots[index+7] = newObject;
        }
    }
    else if (component.status === Component.Error) {
        console.log("Error: ");
        console.log(component.errorString() );
    }
}

function toIndex(suite, number)
{
    return number + (suite*13);
}

function anchorCardOverOther(cardOnTop, cardBelow, offset)
{
    if( (cardBelow !== undefined) &&
        (cardOnTop !== cardBelow) )
    {
        cardOnTop.anchors.centerIn = cardBelow;
        cardOnTop.anchors.verticalCenterOffset = offset;
        cardOnTop.z = Qt.binding(function() {return cardBelow.z+1});
        return true;
    }
    return false;
}

function cardReadyToAnchor(cardIndex)
{
    if( !(52 > cardIndex) )
    {
        return false;
    }

    var cardToAnchor = deck[cardIndex];
    var selectedCard;
    var isSlot = false;
    var offset = 0;
    for( var index = 0 ; index < 11 ; index++ )
    {
        // First try card slots
        var compareSlot = cardSlots[index];
        if( (compareSlot.x <= cardToAnchor.x) &&
            (cardToAnchor.x < (compareSlot.x + compareSlot.width)) &&
            (compareSlot.y <= cardToAnchor.y) &&
            (cardToAnchor.y < (compareSlot.y + compareSlot.height)) )
        {
            selectedCard = compareSlot;
            isSlot = true;
        }
    }

    for( var index = 0 ; index < 52 ; index++ )
    {
        var compareCard = deck[index];
        // Reject exactly same coordinates to avoid loop reference
        if( (compareCard.x < cardToAnchor.x) &&
            (cardToAnchor.x < (compareCard.x + compareCard.width)) &&
            (compareCard.y < cardToAnchor.y) &&
            (cardToAnchor.y < (compareCard.y + compareCard.height)) )
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
            if( selectedCard.faceDown )
            {
                offset = faceDownCardSeparator;
            }
            else
            {
                offset = cardSeparator;
            }
        }
    }
    return anchorCardOverOther(cardToAnchor, selectedCard, offset);
}
