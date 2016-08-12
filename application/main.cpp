#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "languageselector.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<LanguageSelector>("qtsolitaire.languageselector", 1, 0, "LanguageSelector", LanguageSelector::languageSelectorProvider);

    QQmlApplicationEngine* engine = new QQmlApplicationEngine(&app);
    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
