#ifndef GAMELISTMODELUT_H
#define GAMELISTMODELUT_H
#include <QObject>
class GameListModelUT : public QObject
{
    Q_OBJECT
public:
    GameListModelUT();
signals:
    void updateTrigger();
private Q_SLOTS:
    void init();
    void cleanup();
    void rowCount();
    void columnCount();
    void index();
    void parent();
    void data();
    void roleNames();
    void testForceUpdate();
};

#endif // GAMELISTMODELUT_H
