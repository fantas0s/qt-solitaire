#include "gamelistmodel.h"
#include <QDebug>

#define NUM_OF_GAMES   5

const QString solitaireIds[NUM_OF_GAMES] = {
    "fathersSolitaire",
    "blackRed",
    "napoleon",
    "clock",
    "pyramid"
};

const QString imageFileUris[NUM_OF_GAMES] = {
    "images/fathers_solitaire.png",
    "images/black_red.png",
    "images/napoleons_grave.png",
    "images/the_clock.png",
    "images/pyramid_solitaire.png"
};

GameListModel::GameListModel()
{
}

QModelIndex GameListModel::index(int row, int column,
                          const QModelIndex &parent) const
{
    if( hasIndex(row, column, parent) )
        return createIndex(row, column);
    return QModelIndex();
}

QModelIndex GameListModel::parent(const QModelIndex &child) const
{
    (void)child;
    return QModelIndex();
}

int GameListModel::rowCount(const QModelIndex &parent) const
{
    (void)parent;
    return NUM_OF_GAMES;
}

int GameListModel::columnCount(const QModelIndex &parent) const
{
    (void)parent;
    const int fixedOneForOneColumnList = 1;
    return fixedOneForOneColumnList;
}

QVariant GameListModel::getSolitaireName(const int row) const
{
    switch(row)
    {
    case 0:
    default:
        return tr("TR_Father's Solitaire");
    case 1:
        return tr("TR_Classic Black And Red");
    case 2:
        return tr("TR_Napoleon's Grave");
    case 3:
        return tr("TR_The Clock");
    case 4:
        return tr("TR_Pyramid");
    }
}

QVariant GameListModel::data(const QModelIndex &index, int role) const
{
    if( hasIndex(index.row(), index.column()) )
    {
        switch( role )
        {
        case SolitaireNameRole:
            return getSolitaireName(index.row());
        case SolitareIdRole:
            return solitaireIds[index.row()];
        case SolitaireImageUriRole:
            return imageFileUris[index.row()];
        default:
            return QVariant();
        }
    }
    return QVariant();
}

QHash<int, QByteArray> GameListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[SolitaireNameRole] = "solitaireName";
    roles[SolitareIdRole] = "solitaireId";
    roles[SolitaireImageUriRole] = "imageFile";
    return roles;
}

void GameListModel::forceUpdate()
{
    emit dataChanged(index(0,0),index(NUM_OF_GAMES-1,0));
}
