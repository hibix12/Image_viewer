QT += quick
QT += quickcontrols2
QT += widgets


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        backend.cpp \
        main.cpp \
        myimageprovider.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    Image_Viewer_pl_PL.ts
CONFIG += lrelease
CONFIG += embed_translations
CONFIG += qmltypes
QML_IMPORT_NAME = io.qt.examples.backend
QML_IMPORT_MAJOR_VERSION = 1

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    backend.h \
    myimageprovider.h

DISTFILES += \
    buttons.qml \
    icon/black.png \
    icon/redo.png \
    icon/refresh.png \
    icon/undo.png \
    icon/upload.png

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../Downloads/opencv/build/x64/vc15/lib/ -lopencv_world460
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../Downloads/opencv/build/x64/vc15/lib/ -lopencv_world460d
else:unix: LIBS += -L$$PWD/../../Downloads/opencv/build/x64/vc15/lib/ -lopencv_world460

INCLUDEPATH += $$PWD/../../Downloads/opencv/build/x64/vc15
DEPENDPATH += $$PWD/../../Downloads/opencv/build/x64/vc15
