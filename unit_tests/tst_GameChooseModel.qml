import QtQuick 2.2
import QtTest 1.0
import "../application"

TestCase {
    name: "GameChooseModelTests"
    width: 800
    height: 480
    when: windowShown

    GameChooseModel {
        id: modelToTest
    }

    function test_model_values() {
        compare(modelToTest.get(0).imageFile, "images/fathers_solitaire.png")
        compare(modelToTest.get(0).solitaireName, qsTr("&Father's Solitaire"))
        compare(modelToTest.get(0).solitaireId, "fathersSolitaire")
        compare(modelToTest.get(1).imageFile, "images/pyramid_solitaire.png")
        compare(modelToTest.get(1).solitaireName, qsTr("&Pyramid"))
        compare(modelToTest.get(1).solitaireId, "pyramid")
        compare(modelToTest.get(2).imageFile, "images/napoleons_grave.png")
        compare(modelToTest.get(2).solitaireName, qsTr("&Napoleon's Grave"))
        compare(modelToTest.get(2).solitaireId, "napoleon")
        compare(modelToTest.get(3).imageFile, "images/the_clock.png")
        compare(modelToTest.get(3).solitaireName, qsTr("&The Clock"))
        compare(modelToTest.get(3).solitaireId, "clock")
        compare(modelToTest.get(4).imageFile, "images/black_red.png")
        compare(modelToTest.get(4).solitaireName, qsTr("&Classic Black And Red"))
        compare(modelToTest.get(4).solitaireId, "blackRed")
    }
}
