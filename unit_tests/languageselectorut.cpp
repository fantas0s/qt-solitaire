#include "languageselectorut.h"
#include "../application/languageselector.h"
#include <QtTest>

LanguageSelectorUT::LanguageSelectorUT()
{
}

void LanguageSelectorUT::init()
{
}

void LanguageSelectorUT::cleanup()
{
}

void LanguageSelectorUT::testCallBack()
{
    QCOMPARE(LanguageSelector::instance, (void*)Q_NULLPTR);
    LanguageSelector* testObject = qobject_cast<LanguageSelector *>(LanguageSelector::languageSelectorProvider(Q_NULLPTR, Q_NULLPTR));
    QVERIFY(testObject);
    QCOMPARE(LanguageSelector::instance, testObject);
    LanguageSelector* testObject2 = qobject_cast<LanguageSelector *>(LanguageSelector::languageSelectorProvider(Q_NULLPTR, Q_NULLPTR));
    QVERIFY(testObject2);
    QCOMPARE(testObject2, testObject);
/*
    myTranslator = new QTranslator();
    myTranslator->load("texts_en");
    qApp->installTranslator(myTranslator);
*/
}
/*
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
*/
