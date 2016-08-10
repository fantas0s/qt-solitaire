import QtQuick 2.2
import QtQuick.Window 2.2

Window {
    visible:true
    width: 800
    height: 480

    Desk {
        id: mainObject
        anchors.fill: parent
        visible: false
    }
    GameChooser {
        id: chooser
        anchors.fill: parent
        visible: true
        onGameSelected: {
            if( mainObject.startGame(gameId) )
            {
                mainObject.visible = true;
                chooser.visible = false;
            }
        }
    }
}
