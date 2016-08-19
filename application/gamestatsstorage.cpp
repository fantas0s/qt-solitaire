#include "gamestatsstorage.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

GameStatsStorage* GameStatsStorage::instance = Q_NULLPTR;

GameStatsStorage::GameStatsStorage() :
    language("en")
{
    QFile file("db.txt");
    if( file.open(QIODevice::ReadOnly | QIODevice::Text) )
    {
        // Overwrite defaults with values read from file
        if( !file.atEnd() )
        {
            QString line = getNextLineFromFile(file);
            QString versiontitle = line;
            versiontitle.truncate(8);
            if( QString("Version:") == versiontitle )
            {
                line.remove(0,8);
                if( QString("1.0") == line )
                {
                    if( !file.atEnd() )
                    {
                        language = getNextLineFromFile(file);
                    }
                }
            }
        }
        file.close();
    }
}

GameStatsStorage::~GameStatsStorage()
{
}

GameStatsStorage* GameStatsStorage::getInstance()
{
    if( !instance )
        instance = new GameStatsStorage();
    return instance;
}

#ifdef UNIT_TEST
void GameStatsStorage::deleteInstance()
{
    delete instance;
    instance = Q_NULLPTR;
}
#endif

QString GameStatsStorage::getNextLineFromFile(QFile& file)
{
    QString readline = file.readLine();
    readline.remove(QChar('\n'));
    return readline;
}

QString GameStatsStorage::getLanguage()
{
    return language;
}

void GameStatsStorage::writeSettingsToFile()
{
    QFile file("db.txt");
    if( file.open(QIODevice::WriteOnly | QIODevice::Text) )
    {
        QTextStream out(&file);
        out << "Version:1.0\n";
        out << language << "\n";
        file.close();
    }
}

void GameStatsStorage::setLanguage(QString lang)
{
    language = lang;
    writeSettingsToFile();
}
