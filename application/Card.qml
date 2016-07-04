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
        faceDown = !faceDown
    }
    onPressed: {
        if( belowMe )
        {
            belowMe.aboveMe = null;
            belowMe = null;
        }
        anchors.centerIn = undefined;
        storedX = x;
        storedY = y;
        z = 1000;
    }
    onReleased: {
        if( false === mainObject.cardReadyToAnchor(myId) )
        {
            x = storedX+1;
            y = storedY+1;
            if( false === mainObject.cardReadyToAnchor(myId) )
            {
                x--;
                y--;
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
