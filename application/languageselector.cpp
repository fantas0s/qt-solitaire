#include "languageselector.h"
#include <QTranslator>
#include <QtGui>
#include <QQmlEngine>
#include <QDebug>

int calls = 0;
int constructorcalls = 0;

LanguageSelector::LanguageSelector()
{
    constructorcalls++;
    qDebug() << "constructor," << constructorcalls << "calls.";
    myTranslator = new QTranslator();
    myTranslator->load("texts_en");
    qApp->installTranslator(myTranslator);
}

QString LanguageSelector::getBindingString()
{
    return bindingString;
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
    calls++;
    qDebug() << "new object requested," << calls << "calls.";
    return new LanguageSelector();
}
