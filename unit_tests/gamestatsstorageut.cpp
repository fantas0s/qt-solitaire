#include "gamestatsstorageut.h"
#include "../application/gamestatsstorage.h"
#include <QtTest>
#include <QSignalSpy>

GameStatsStorageUT::GameStatsStorageUT()
{
}

void GameStatsStorageUT::init()
{
    QFile file("db.txt");
    if( file.open(QIODevice::WriteOnly | QIODevice::Text) )
    {
        QTextStream out(&file);
        out << "";
        file.close();
    }
}

void GameStatsStorageUT::cleanup()
{
}

void GameStatsStorageUT::getInstance()
{
    GameStatsStorage* storage = GameStatsStorage::getInstance();
    QVERIFY(storage);
    QCOMPARE(storage, GameStatsStorage::instance);
    GameStatsStorage* storage2 = GameStatsStorage::getInstance();
    QCOMPARE(storage, storage2);
    storage->deleteInstance();
    QCOMPARE(GameStatsStorage::instance, (void*)Q_NULLPTR);
}

void GameStatsStorageUT::readDefaultValues()
{
    GameStatsStorage* storage = GameStatsStorage::getInstance();
    QCOMPARE(storage->getLanguage(), QString("en"));
}

void GameStatsStorageUT::writeAndReadValues()
{
    GameStatsStorage* storage = GameStatsStorage::getInstance();
    storage->setLanguage(QString("fi"));
    QCOMPARE(storage->getLanguage(), QString("fi"));
    storage->deleteInstance();
    storage = GameStatsStorage::getInstance();
    QCOMPARE(storage->getLanguage(), QString("fi"));
}
