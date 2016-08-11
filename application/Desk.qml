import QtQuick 2.2
import "logic.js" as Logic

Rectangle {
    color: "green"
    function startGame(gameId) {
        if( gameId === "fathersSolitaire" )
        {
            Logic.deleteSlots();
            Logic.startFathersSolitaire();
            return true;
        }
        return false;
    }
    function cardReadyToAnchor(index, applyRuling) {
        return Logic.cardReadyToAnchor(index, applyRuling);
    }
    Component.onCompleted: {
        Logic.createDeck();
    }
}
