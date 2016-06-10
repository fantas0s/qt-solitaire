.pragma library

var pakka = new Array(52);
var korttiVali = 35;

function startFreeRange() {
    createDeck();
    shuffleDeck();
    var index = 0;
    var xOrigin = 30;

    for( var column = 0 ; (column < 7) && (index < 52) ; column++ )
    {
        var yOrigin = 140;
        for( var round = 0 ; ((round < 7) || ((column < 3) && (round < 8))) && (index < 52) ; round++ )
        {
            if( round > column )
            {
                anchorCardOverOther(pakka[index], pakka[index-1]);
            }
            else
            {
                pakka[index].x = xOrigin;
                pakka[index].y = yOrigin;
                pakka[index].z = pakka[index].y;
                yOrigin += 5;
            }
            if( round >= column )
            {
                pakka[index].naamaAlas = false;
            }
            index++;
        }
        xOrigin += 110;
    }
}

function createDeck() {
    var component = Qt.createComponent("Kortti.qml");
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
    var suiteText = "pata"
    switch( suite )
    {
    case 0:
        suiteText = "ruutu";
        break;
    case 1:
        suiteText = "risti";
        break;
    case 2:
        suiteText = "hertta";
        break;
    default:
        break;
    }

    var newObject = component.createObject(mainObject);
    newObject.x = 30;
    newObject.y = 30;
    newObject.numero = number+1;
    newObject.maa = suiteText;
    newObject.tunniste = toIndex(suite,number);
    pakka[newObject.tunniste] = newObject;
}

function shuffleDeck()
{
    for( var index = 0 ; index < 52 ; index++ ) {
        var cardToMove = pakka[index];
        var newIndex = Math.floor(Math.random()*52);
        pakka[index] = pakka[newIndex];
        pakka[newIndex] = cardToMove;
    }
    for( var index = 0 ; index < 52 ; index++ ) {
        pakka[index].z = 10+index;
        pakka[index].tunniste = index;
    }
}

function toIndex(suite, number)
{
    return number + (suite*13);
}

function anchorCardOverOther(cardOnTop, cardBelow)
{
    if( (cardBelow !== undefined) &&
        cardOnTop.tunniste !== cardBelow.tunniste )
    {
        cardOnTop.anchors.centerIn = cardBelow;
        cardOnTop.anchors.verticalCenterOffset = korttiVali;
        cardOnTop.z = Qt.binding(function() {return cardBelow.z+1});
    }
}

function cardReadyToAnchor(cardIndex)
{
    var cardToAnchor = pakka[cardIndex];
    var selectedCard;
    for( var index = 0 ; index < 52 ; index++ )
    {
        // Reject exactly same coordinates to avoid loop reference
        if( (pakka[index].x < cardToAnchor.x) &&
            (cardToAnchor.x < (pakka[index].x + pakka[index].width)) &&
            (pakka[index].y < cardToAnchor.y) &&
            (cardToAnchor.y < (pakka[index].y + pakka[index].height)) )
        {
            if( selectedCard == undefined )
            {
                selectedCard = pakka[index];
            }
            else
            {
                if( pakka[index].z > selectedCard.z )
                {
                    selectedCard = pakka[index];
                }
            }
        }
    }
    anchorCardOverOther(cardToAnchor, selectedCard);
}
