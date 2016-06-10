import QtQuick 2.2

Item {
    id: __suiteIcon
    property string suite: "heart"
    width: 10
    height: 10
    Heart {
        visible: __suiteIcon.suite == "heart" ? true : false
    }
    Diamond {
        visible: __suiteIcon.suite == "diamond" ? true : false
    }
    Spade {
        visible: __suiteIcon.suite == "spade" ? true : false
    }
    Clubs {
        visible: __suiteIcon.suite == "clubs" ? true : false
    }
}
