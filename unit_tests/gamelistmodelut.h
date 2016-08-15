#ifndef GAMELISTMODELUT_H
#define GAMELISTMODELUT_H
#include <QObject>
class GameListModelUT : public QObject
{
    Q_OBJECT
public:
    GameListModelUT();

private Q_SLOTS:
    void init();
    void cleanup();
    void rowCount();
    void columnCount();
    void index();
    void parent();
    void data();
};

#endif // GAMELISTMODELUT_H
