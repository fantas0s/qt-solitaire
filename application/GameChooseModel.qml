import QtQuick 2.2

ListModel {
    ListElement {
        imageFile: "images/fathers_solitaire.png"
        solitaireName: qsTr("&Father's Solitaire")
        solitaireId: "fathersSolitaire"
    }
    ListElement {
        imageFile: "images/pyramid_solitaire.png"
        solitaireName: qsTr("&Pyramid")
        solitaireId: "pyramid"
    }
    ListElement {
        imageFile: "images/napoleons_grave.png"
        solitaireName: qsTr("&Napoleon's Grave")
        solitaireId: "napoleon"
    }
    ListElement {
        imageFile: "images/the_clock.png"
        solitaireName: qsTr("&The Clock")
        solitaireId: "clock"
    }
    ListElement {
        imageFile: "images/black_red.png"
        solitaireName: qsTr("&Classic Black And Red")
        solitaireId: "blackRed"
    }
}
