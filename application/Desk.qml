import QtQuick 2.2
import "logic.js" as Logic

Rectangle {
    color: "green"
    function startGame(gameName) {
        if( gameName === "Father's Solitaire" )
        {
            Logic.startFathersSolitaire();
            return true;
        }
        return false;
    }
    function cardReadyToAnchor(index, applyRuling) {
        return Logic.cardReadyToAnchor(index, applyRuling);
    }
}
