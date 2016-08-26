TEMPLATE = app

QT += qml quick

SOURCES += main.cpp \
    languageselector.cpp \
    gamelistmodel.cpp \
    gamestatsstorage.cpp

lupdate_only{
SOURCES += *.qml \
          *.js
}

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    DeactivableButtonStyle.qml

TRANSLATIONS += translations/texts_en.ts \
               translations/texts_fi.ts

HEADERS += \
    languageselector.h \
    gamelistmodel.h \
    gamestatsstorage.h
