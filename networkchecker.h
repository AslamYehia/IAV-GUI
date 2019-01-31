#ifndef NETWORKCHECKER_H
#define NETWORKCHECKER_H

#include <QNetworkAccessManager>
#include <QEventLoop>
#include <QNetworkReply>
#include <QUrlQuery>


#include <QObject>

class NetworkChecker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool checkNetwork READ checkNetwork)

    Q_PROPERTY(bool conn READ conn NOTIFY connChanged)
public:
    explicit NetworkChecker(QObject *parent = nullptr);

    bool conn();
    bool checkNetwork();

private:
    bool m_connected;

signals:

    void connChanged();
public slots:
};

#endif // NETWORKCHECKER_H
