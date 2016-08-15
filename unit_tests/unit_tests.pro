TEMPLATE = app
TARGET = tst_qt-solitaire
CONFIG += warn_on qmltestcase
SOURCES += \
    tst_qt-solitaire.cpp \
    ../application/languageselector.cpp \
    languageselectorut.cpp \
    gamelistmodelut.cpp \
    ../application/gamelistmodel.cpp

DISTFILES += \
    tst_Suiteicon.qml \
    tst_logic.qml \
    tst_CardSlot.qml \
    tst_Card.qml \
    tst_Desk.qml \
    tst_GameChooser.qml \
    tst_GameChooseModel.qml \
    tst_GameMenu.qml

HEADERS += \
    ../application/languageselector.h \
    languageselectorut.h \
    gamelistmodelut.h \
    ../application/gamelistmodel.h
