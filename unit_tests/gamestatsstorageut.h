#ifndef GAMESTATSSTORAGEUT_H
#define GAMESTATSSTORAGEUT_H
#include <QObject>
class GameStatsStorageUT : public QObject
{
    Q_OBJECT
public:
    GameStatsStorageUT();
private Q_SLOTS:
    void init();
    void cleanup();
    void getInstance();
    void readDefaultValues();
    void writeAndReadValues();
};
#endif // GAMESTATSSTORAGEUT_H
