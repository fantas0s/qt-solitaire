#ifndef LANGUAGESELECTOR_H
#define LANGUAGESELECTOR_H
#include <QObject>

class QTranslator;
class QQmlEngine;
class QJSEngine;

class LanguageSelector : public QObject
{
public:
    LanguageSelector();
    QString getBindingString();
    Q_INVOKABLE void languageChange(QString language);
    static QObject* languageSelectorProvider(QQmlEngine* engine, QJSEngine* scriptEngine);
signals:
    void bindingStringChanged();
private:
    Q_OBJECT
    Q_PROPERTY(QString bindingString READ getBindingString NOTIFY bindingStringChanged)
    QString bindingString;
    QTranslator* myTranslator;
};
#endif // LANGUAGESELECTOR_H
