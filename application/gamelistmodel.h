#ifndef GAMELISTMODEL_H
#define GAMELISTMODEL_H
#include <QAbstractItemModel>
class GameListModel : public QAbstractItemModel
{
public:
    enum {
        SolitaireNameRole = Qt::DisplayRole+1,
        SolitaireImageUriRole = Qt::DisplayRole+2,
        SolitareIdRole = Qt::DisplayRole+3
    };
    GameListModel();
    Q_INVOKABLE QModelIndex index(int row, int column,
                              const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE QModelIndex parent(const QModelIndex &child) const;
    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE int columnCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
private:
    QVariant getSolitaireName(const int row) const;
};

#endif // GAMELISTMODEL_H
