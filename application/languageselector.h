#ifndef LANGUAGESELECTOR_H
#define LANGUAGESELECTOR_H
#include <QObject>

class QTranslator;

class LanguageSelector : public QObject
{
public:
    LanguageSelector();
    QString getBindingString();
    Q_INVOKABLE void languageChange(QString language);
signals:
    void bindingStringChanged();
private:
    Q_OBJECT
    Q_PROPERTY(QString bindingString READ getBindingString NOTIFY bindingStringChanged)
    QString bindingString;
    QTranslator* myTranslator;
};
#endif // LANGUAGESELECTOR_H
