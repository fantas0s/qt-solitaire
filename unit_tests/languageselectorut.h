#ifndef LANGUAGESELECTORUT_H
#define LANGUAGESELECTORUT_H
#include <QObject>
class LanguageSelectorUT : public QObject
{
    Q_OBJECT
public:
    LanguageSelectorUT();

private Q_SLOTS:
    void init();
    void cleanup();
    void testCallBack();
};
#endif // LANGUAGESELECTORUT_H
