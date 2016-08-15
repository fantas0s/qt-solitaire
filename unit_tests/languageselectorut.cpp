#include "languageselectorut.h"
#include "../application/languageselector.h"
#include <QtTest>
#include <QSignalSpy>

LanguageSelectorUT::LanguageSelectorUT()
{
}

void LanguageSelectorUT::init()
{
}

void LanguageSelectorUT::cleanup()
{
}

void LanguageSelectorUT::callBack()
{
    QCOMPARE(LanguageSelector::instance, (void*)Q_NULLPTR);
    LanguageSelector* testObject = qobject_cast<LanguageSelector *>(LanguageSelector::languageSelectorProvider(Q_NULLPTR, Q_NULLPTR));
    QVERIFY(testObject);
    QCOMPARE(LanguageSelector::instance, testObject);
    QVERIFY(testObject->myTranslator);
    LanguageSelector* testObject2 = qobject_cast<LanguageSelector *>(LanguageSelector::languageSelectorProvider(Q_NULLPTR, Q_NULLPTR));
    QVERIFY(testObject2);
    QCOMPARE(testObject2, testObject);
}

void LanguageSelectorUT::getString()
{
    LanguageSelector* testObject = qobject_cast<LanguageSelector *>(LanguageSelector::languageSelectorProvider(Q_NULLPTR, Q_NULLPTR));
    QCOMPARE(testObject->getBindingString(), QString(""));
}

void LanguageSelectorUT::bindingStringChanged()
{
    LanguageSelector* testObject = qobject_cast<LanguageSelector *>(LanguageSelector::languageSelectorProvider(Q_NULLPTR, Q_NULLPTR));
    QSignalSpy spy(testObject, SIGNAL(bindingStringChanged()));
    QCOMPARE(spy.count(), 0);
    testObject->languageChange(QString("fi"));
    QCOMPARE(spy.count(), 1);
    QCOMPARE(testObject->getBindingString(), QString(""));
}
