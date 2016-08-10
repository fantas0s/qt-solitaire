#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QTranslator* myTranslator;
    myTranslator = new QTranslator(&app);
    myTranslator->load("texts_en");
    app.installTranslator(myTranslator);
    QQmlApplicationEngine* engine = new QQmlApplicationEngine(&app);
    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
