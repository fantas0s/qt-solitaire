TEMPLATE = app

QT += qml quick

SOURCES += main.cpp \
    languageselector.cpp

lupdate_only{
SOURCES += *.qml \
          *.js
}

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES +=

TRANSLATIONS += translations/texts_en.ts \
               translations/texts_fi.ts

HEADERS += \
    languageselector.h
