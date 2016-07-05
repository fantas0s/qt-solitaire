import QtQuick 2.2
import "logic.js" as Logic

Rectangle {
    color: "green"
    function startGame(gameName) {
        if( gameName === "Father's Solitaire" )
        {
            Logic.startFreeRange();
            return true;
        }
        return false;
    }
    function cardReadyToAnchor(tunniste) {
        return Logic.cardReadyToAnchor(tunniste);
    }
}
