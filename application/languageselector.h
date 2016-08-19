#ifndef LANGUAGESELECTOR_H
#define LANGUAGESELECTOR_H
#include <QObject>

class QTranslator;
class QQmlEngine;
class QJSEngine;

class LanguageSelector : public QObject
{
    friend class LanguageSelectorUT;
public:
    QString getBindingString();
    Q_INVOKABLE void languageChange(QString language);
    static QObject* languageSelectorProvider(QQmlEngine* engine, QJSEngine* scriptEngine);
signals:
    void bindingStringChanged();
private:
    LanguageSelector();
    Q_OBJECT
    Q_PROPERTY(QString bindingString READ getBindingString NOTIFY bindingStringChanged)
    QTranslator* myTranslator;
    static LanguageSelector* instance;
    void updateTranslator(QString language);
};
#endif // LANGUAGESELECTOR_H
