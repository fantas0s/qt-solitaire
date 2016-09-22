import QtQuick 2.2
import QtTest 1.0
import "../application"
import qtsolitaire.gamelistmodel 1.0

TestCase {
    name: "GameListModelTests"
    width: 800
    height: 480
    when: windowShown

    GameListModel {
        id: modelToTest
    }

    function test_model_values() {
        compare(modelToTest.data(modelToTest.index(0,0), 257), qsTr("TR_Father's Solitaire"))
        compare(modelToTest.data(modelToTest.index(0,0), 258), "images/fathers_solitaire.png")
        compare(modelToTest.data(modelToTest.index(0,0), 259), "fathersSolitaire")
        compare(modelToTest.data(modelToTest.index(4,0), 257), qsTr("TR_Pyramid"))
        compare(modelToTest.data(modelToTest.index(4,0), 258), "images/pyramid_solitaire.png")
        compare(modelToTest.data(modelToTest.index(4,0), 259), "pyramid")
    }
}
