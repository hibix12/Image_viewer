#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "myimageprovider.h"

#include <QLocale>
#include <QTranslator>
#include <backend.h>

int main(int argc, char *argv[])
{
    BackEnd *back = new BackEnd;

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "Image_Viewer_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;

    MyImageProvider myImageProvider;

    engine.addImageProvider(QLatin1String("MyImageProvider"), &myImageProvider);
    engine.rootContext()->setContextProperty("back",back);

    const QUrl url(QStringLiteral("qrc:/main.qml"));    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
