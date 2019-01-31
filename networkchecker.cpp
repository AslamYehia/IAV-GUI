#include "networkchecker.h"

NetworkChecker::NetworkChecker(QObject *parent) : QObject(parent)
{
    this->m_connected = false;
}

bool NetworkChecker::checkNetwork()
{
    QNetworkAccessManager * manager = new QNetworkAccessManager();

    // always ping google and check result to determin internet connection
    QUrl url("https://google.com");

    // send request and wait for reply
    QNetworkReply * reply = manager->get( QNetworkRequest(url) );
    QEventLoop eventLoop;
    eventLoop.startTimer(100, Qt::CoarseTimer);
    connect(reply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec();

    this->m_connected = !reply->error();
    return m_connected;
}
bool NetworkChecker::conn()
{
    return this->m_connected;
}
