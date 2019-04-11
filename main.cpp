#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "weather.h"
#include "networkchecker.h"
#include "joycontroler.h"
#include <QtNetwork>
#include <QtQuickControls2/QtQuickControls2>
#include <QStandardPaths>


QString static videoPath = QDir::currentPath()+"/asserts/";


int main(int argc, char *argv[])
{
    videoPath = "file://"+ videoPath;

    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);


    // register weather class so we can use them from qml front end
    qmlRegisterType<Weather>("io.simulation.weather", 1,0, "Weather" );
    qmlRegisterType<NetworkChecker>("io.simulation.networkchecker", 1,0, "NetworkChecker" );
    // qmlRegisterType<JoyControler>("io.simulation.joycontroler", 1,0, "JoyControler" );

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    engine.rootContext()->setContextProperty("videoPath", videoPath);

    return app.exec();
}
