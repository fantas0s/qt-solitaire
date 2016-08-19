#include "languageselector.h"
#include <QTranslator>
#include <QtGui>
#include <QQmlEngine>
#include "gamestatsstorage.h"

LanguageSelector* LanguageSelector::instance = Q_NULLPTR;

LanguageSelector::LanguageSelector()
{
    GameStatsStorage* storage = GameStatsStorage::getInstance();
    myTranslator = new QTranslator();
    updateTranslator(storage->getLanguage());
}

QString LanguageSelector::getBindingString()
{
    return QString("");
}

void LanguageSelector::updateTranslator(QString language)
{
    myTranslator->load(QString("texts_") + language);
    qApp->installTranslator(myTranslator);
}

void LanguageSelector::languageChange(QString language)
{
    qApp->removeTranslator(myTranslator);
    updateTranslator(language);
    GameStatsStorage* storage = GameStatsStorage::getInstance();
    storage->setLanguage(language);
    emit bindingStringChanged();
}

QObject* LanguageSelector::languageSelectorProvider(QQmlEngine* engine, QJSEngine* scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    if( !instance )
        instance = new LanguageSelector();
    return instance;
}
