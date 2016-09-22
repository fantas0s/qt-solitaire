#include "gamelistmodelut.h"
#include "../application/gamelistmodel.h"
#include <QtTest>
#include <QSignalSpy>

static const int numOfGames = 5;
static const int numberOfColumnsInOneColumnList = 1;

GameListModelUT::GameListModelUT()
{
}

void GameListModelUT::init()
{
}

void GameListModelUT::cleanup()
{
}

void GameListModelUT::rowCount()
{
    GameListModel* listModel = new GameListModel();
    QAbstractItemModel* itemModel = qobject_cast<QAbstractItemModel*>(listModel);
    QCOMPARE(itemModel->rowCount(), numOfGames);
    delete listModel;
}

void GameListModelUT::columnCount()
{
    GameListModel* listModel = new GameListModel();
    QAbstractItemModel* itemModel = qobject_cast<QAbstractItemModel*>(listModel);
    QCOMPARE(itemModel->columnCount(), numberOfColumnsInOneColumnList);
    delete listModel;
}

void GameListModelUT::index()
{
    GameListModel* listModel = new GameListModel();
    QAbstractItemModel* itemModel = qobject_cast<QAbstractItemModel*>(listModel);
    QCOMPARE(itemModel->index(numOfGames, 0), QModelIndex()); //invalid index
    QCOMPARE(itemModel->index(0, numberOfColumnsInOneColumnList), QModelIndex()); //invalid index
    QCOMPARE(itemModel->index(numOfGames-1, 0).row(), numOfGames-1); //valid index
    QVERIFY(itemModel->index(numOfGames-1, 0).isValid()); //valid index
    QVERIFY(itemModel->index(0, 0).isValid()); //valid index
    delete listModel;
}

void GameListModelUT::parent()
{
    GameListModel* listModel = new GameListModel();
    QAbstractItemModel* itemModel = qobject_cast<QAbstractItemModel*>(listModel);
    QCOMPARE(itemModel->parent(itemModel->index(0,0)), QModelIndex());
    delete listModel;
}

void GameListModelUT::data()
{
    GameListModel* listModel = new GameListModel();
    QAbstractItemModel* itemModel = qobject_cast<QAbstractItemModel*>(listModel);
    QCOMPARE(itemModel->data(itemModel->index(0,0), Qt::UserRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(0,0), GameListModel::SolitareIdRole).toString(), QString("fathersSolitaire"));
    QCOMPARE(itemModel->data(itemModel->index(0,0), GameListModel::SolitaireNameRole).toString(), QString("TR_Father's Solitaire"));
    QCOMPARE(itemModel->data(itemModel->index(0,0), GameListModel::SolitaireImageUriRole).toString(), QString("images/fathers_solitaire.png"));
    QCOMPARE(itemModel->data(itemModel->index(1,0), GameListModel::SolitareIdRole).toString(), QString("blackRed"));
    QCOMPARE(itemModel->data(itemModel->index(1,0), GameListModel::SolitaireNameRole).toString(), QString("TR_Classic Black And Red"));
    QCOMPARE(itemModel->data(itemModel->index(1,0), GameListModel::SolitaireImageUriRole).toString(), QString("images/black_red.png"));
    QCOMPARE(itemModel->data(itemModel->index(2,0), GameListModel::SolitareIdRole).toString(), QString("napoleon"));
    QCOMPARE(itemModel->data(itemModel->index(2,0), GameListModel::SolitaireNameRole).toString(), QString("TR_Napoleon's Grave"));
    QCOMPARE(itemModel->data(itemModel->index(2,0), GameListModel::SolitaireImageUriRole).toString(), QString("images/napoleons_grave.png"));
    QCOMPARE(itemModel->data(itemModel->index(3,0), GameListModel::SolitareIdRole).toString(), QString("clock"));
    QCOMPARE(itemModel->data(itemModel->index(3,0), GameListModel::SolitaireNameRole).toString(), QString("TR_The Clock"));
    QCOMPARE(itemModel->data(itemModel->index(3,0), GameListModel::SolitaireImageUriRole).toString(), QString("images/the_clock.png"));
    QCOMPARE(itemModel->data(itemModel->index(4,0), GameListModel::SolitareIdRole).toString(), QString("pyramid"));
    QCOMPARE(itemModel->data(itemModel->index(4,0), GameListModel::SolitaireNameRole).toString(), QString("TR_Pyramid"));
    QCOMPARE(itemModel->data(itemModel->index(4,0), GameListModel::SolitaireImageUriRole).toString(), QString("images/pyramid_solitaire.png"));
    QCOMPARE(itemModel->data(itemModel->index(numOfGames,0), Qt::UserRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(numOfGames,0), GameListModel::SolitareIdRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(numOfGames,0), GameListModel::SolitaireNameRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(numOfGames,0), GameListModel::SolitaireImageUriRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(0,numberOfColumnsInOneColumnList), Qt::UserRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(0,numberOfColumnsInOneColumnList), GameListModel::SolitareIdRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(0,numberOfColumnsInOneColumnList), GameListModel::SolitaireNameRole), QVariant());
    QCOMPARE(itemModel->data(itemModel->index(0,numberOfColumnsInOneColumnList), GameListModel::SolitaireImageUriRole), QVariant());
    delete listModel;
}

void GameListModelUT::roleNames()
{
    GameListModel* listModel = new GameListModel();
    QAbstractItemModel* itemModel = qobject_cast<QAbstractItemModel*>(listModel);
    QHash<int, QByteArray> roles = itemModel->roleNames();
    QCOMPARE(roles.count(), 3);
    QCOMPARE(roles.value((int)GameListModel::SolitaireImageUriRole), QByteArray("imageFile"));
    QCOMPARE(roles.value((int)GameListModel::SolitaireNameRole), QByteArray("solitaireName"));
    QCOMPARE(roles.value((int)GameListModel::SolitareIdRole), QByteArray("solitaireId"));
    delete listModel;
}

void GameListModelUT::testForceUpdate()
{
    GameListModel* listModel = new GameListModel();
    QObject::connect(this, SIGNAL(updateTrigger()),
                     listModel, SLOT(forceUpdate()));
    QAbstractItemModel* itemModel = qobject_cast<QAbstractItemModel*>(listModel);
    QSignalSpy spy(itemModel, SIGNAL(dataChanged(const QModelIndex, const QModelIndex, const QVector<int>&)));
    QCOMPARE(spy.count(), 0);
    emit updateTrigger();
    QCOMPARE(spy.count(), 1);
    delete listModel;
}
