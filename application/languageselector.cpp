#include "languageselector.h"
#include <QTranslator>
#include <QtGui>
#include <QQmlEngine>

LanguageSelector* LanguageSelector::instance = Q_NULLPTR;

LanguageSelector::LanguageSelector()
{
    myTranslator = new QTranslator();
    myTranslator->load("texts_en");
    qApp->installTranslator(myTranslator);
}

QString LanguageSelector::getBindingString()
{
    return QString("");
}

void LanguageSelector::languageChange(QString language)
{
    qApp->removeTranslator(myTranslator);
    myTranslator->load(QString("texts_") + language);
    qApp->installTranslator(myTranslator);
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
