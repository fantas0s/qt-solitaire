#include <QtQuickTest/quicktest.h>
#include <QQmlApplicationEngine>
#include "../application/languageselector.h"
#include "../application/gamelistmodel.h"
#include "languageselectorut.h"
#include "gamelistmodelut.h"
int main(int argc, char **argv)
{
    QTEST_ADD_GPU_BLACKLIST_SUPPORT
    QTEST_SET_MAIN_SOURCE_PATH
    LanguageSelectorUT lsUT;
    int cppUtReturnValue = QTest::qExec(&lsUT, argc, argv);
    if( cppUtReturnValue )
        return cppUtReturnValue;

    GameListModelUT glmUT;
    cppUtReturnValue = QTest::qExec(&glmUT, argc, argv);
    if( cppUtReturnValue )
        return cppUtReturnValue;

    qmlRegisterType<GameListModel>("qtsolitaire.gamelistmodel", 1, 0, "GameListModel");
    qmlRegisterSingletonType<LanguageSelector>("qtsolitaire.languageselector", 1, 0, "LanguageSelector", LanguageSelector::languageSelectorProvider);
    return quick_test_main(argc, argv, "qt-solitaire", QUICK_TEST_SOURCE_DIR);
}
