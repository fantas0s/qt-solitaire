#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "languageselector.h"
#include "gamelistmodel.h"

#ifdef UNIT_TEST
#error "Unit test compilation for application!!!"
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<GameListModel>("qtsolitaire.gamelistmodel", 1, 0, "GameListModel");
    qmlRegisterSingletonType<LanguageSelector>("qtsolitaire.languageselector", 1, 0, "LanguageSelector", LanguageSelector::languageSelectorProvider);

    QQmlApplicationEngine* engine = new QQmlApplicationEngine(&app);
    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
