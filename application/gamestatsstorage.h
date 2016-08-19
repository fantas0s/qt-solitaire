#ifndef GAMESTATSSTORAGE_H
#define GAMESTATSSTORAGE_H
#include <QString>
#include <QFile>
class GameStatsStorage
{
    friend class GameStatsStorageUT;
public:
    static GameStatsStorage* getInstance();
#ifdef UNIT_TEST
    void deleteInstance();
#endif
    QString getLanguage();
    void setLanguage(QString lang);
private:
    GameStatsStorage();
    ~GameStatsStorage();
    static GameStatsStorage* instance;
    QString getNextLineFromFile(QFile& file);
    QString language;
    void writeSettingsToFile();
};

#endif // GAMESTATSSTORAGE_H
