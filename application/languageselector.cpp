#include "languageselector.h"
#include <QTranslator>
#include <QtGui>

LanguageSelector::LanguageSelector()
{
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
