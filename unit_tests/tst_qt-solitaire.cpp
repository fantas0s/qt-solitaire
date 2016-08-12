#include <QtQuickTest/quicktest.h>
#include <QQmlApplicationEngine>
#include "../application/languageselector.h"
#include "languageselectorut.h"
int main(int argc, char **argv)
{
    QTEST_ADD_GPU_BLACKLIST_SUPPORT
    QTEST_SET_MAIN_SOURCE_PATH
    qmlRegisterSingletonType<LanguageSelector>("qtsolitaire.languageselector", 1, 0, "LanguageSelector", LanguageSelector::languageSelectorProvider);
    LanguageSelectorUT lsUT;
    int cppUtReturnValue = QTest::qExec(&lsUT, argc, argv);
    if( cppUtReturnValue )
        return cppUtReturnValue;
    return quick_test_main(argc, argv, "qt-solitaire", QUICK_TEST_SOURCE_DIR);
}
