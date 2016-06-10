var deck = new Array(52);
var cardSeparator = 30;
var firstRowY = 40;

function startFreeRange() {
    createDeck();
    shuffleDeck();
    var index = 0;
    var xOrigin = 30;

    for( var column = 0 ; (column < 7) && (index < 52) ; column++ )
    {
        var yOrigin = firstRowY;
        for( var round = 0 ; ((round < 7) || ((column < 3) && (round < 8))) && (index < 52) ; round++ )
        {
            if( round > column )
            {
                anchorCardOverOther(deck[index], deck[index-1]);
            }
            else
            {
                deck[index].x = xOrigin;
                deck[index].y = yOrigin;
                deck[index].z = deck[index].y;
                yOrigin += 5;
            }
            if( round >= column )
            {
                deck[index].faceDown = false;
            }
            index++;
        }
        xOrigin += 110;
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
    newObject.x = 30;
    newObject.y = 30;
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

function toIndex(suite, number)
{
    return number + (suite*13);
}

function anchorCardOverOther(cardOnTop, cardBelow)
{
    if( (cardBelow !== undefined) &&
        cardOnTop.myId !== cardBelow.myId )
    {
        cardOnTop.anchors.centerIn = cardBelow;
        cardOnTop.anchors.verticalCenterOffset = cardSeparator;
        cardOnTop.z = Qt.binding(function() {return cardBelow.z+1});
    }
}

function cardReadyToAnchor(cardIndex)
{
    var cardToAnchor = deck[cardIndex];
    var selectedCard;
    for( var index = 0 ; index < 52 ; index++ )
    {
        // Reject exactly same coordinates to avoid loop reference
        if( (deck[index].x < cardToAnchor.x) &&
            (cardToAnchor.x < (deck[index].x + deck[index].width)) &&
            (deck[index].y < cardToAnchor.y) &&
            (cardToAnchor.y < (deck[index].y + deck[index].height)) )
        {
            if( selectedCard == undefined )
            {
                selectedCard = deck[index];
            }
            else
            {
                if( deck[index].z > selectedCard.z )
                {
                    selectedCard = deck[index];
                }
            }
        }
    }
    anchorCardOverOther(cardToAnchor, selectedCard);
}
