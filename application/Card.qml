import QtQuick 2.2
//import "logic.js" as Logic

MouseArea {
    id: __card
    property bool faceDown: true
    property string mySuite: "spade"
    property int myNumber: 0
    property int myId: 0
    property Item belowMe: null
    property Item aboveMe: null
    property int storedX: x
    property int storedY: y
    width: 80
    height: 120
    onClicked: {
        if( faceDown &&
            (aboveMe === null) )
        {
            faceDown = false;
        }
    }
    onPressed: {
        if( !faceDown )
        {
            if( belowMe )
            {
                belowMe.aboveMe = null;
                belowMe = null;
            }
            anchors.centerIn = null;
            storedX = x;
            storedY = y;
            z = 1000;
        }
    }
    onReleased: {
        if( !faceDown )
        {
            if( ((x === storedX) &&
                 (y === storedY)) ||
                ( false === mainObject.cardReadyToAnchor(myId, true) ) )
            {
                x = storedX+1;
                y = storedY+1;
                if( false === mainObject.cardReadyToAnchor(myId, false) )
                {
                    console.log("Card was left to float at x:", x, " y:", y);
                    x--;
                    y--;
                }
            }
        }
    }

    drag.target: __card
    drag.axis: Drag.XandYAxis
    drag.minimumX: 0
    drag.maximumX: parent.width
    drag.minimumY: 0
    drag.maximumY: parent.height
    Image {
        id: tausta
        source: "cardback.jpg"
        anchors.fill: parent
        visible: __card.faceDown
    }
    Rectangle {
        id: cardface
        anchors.fill: parent
        border.color: "black"
        border.width: 1
        radius: 5
        visible: !__card.faceDown

        Suiteicon {
            id: suiteMark1
            x: 6
            y: 5
            suite: __card.mySuite
            number: __card.myNumber
        }

        Suiteicon {
            id: suiteMark2
            x: __card.width-width-6
            y: __card.height-height-5
            suite: __card.mySuite
            number: __card.myNumber
            rotation: 180
        }
    }
}
