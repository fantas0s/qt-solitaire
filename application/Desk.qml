import QtQuick 2.2
import "logic.js" as Logic

Rectangle {
    color: "green"
    Component.onCompleted: {
                Logic.startFreeRange();
            }

    function cardReadyToAnchor(tunniste) {
        return Logic.cardReadyToAnchor(tunniste);
    }
}
