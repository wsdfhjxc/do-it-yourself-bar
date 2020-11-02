#include "DoItYourselfBar.hpp"

#include <QDBusConnection>
#include <QDebug>

DoItYourselfBar::DoItYourselfBar(QObject* parent) :
        QObject(parent),
        dbusService(parent),
        dbusInstanceId(0),
        cfg_DBusInstanceId(0) {

    QObject::connect(&dbusService, &DBusService::dataPassed,
                     this, &DoItYourselfBar::handlePassedData);
}

void DoItYourselfBar::cfg_DBusInstanceIdChanged() {
    auto sessionBus = QDBusConnection::sessionBus();
    sessionBus.registerService(SERVICE_NAME);

    if (dbusInstanceId != 0) {
        QString path = "/id_" + QString::number(dbusInstanceId);
        sessionBus.unregisterObject(path, QDBusConnection::UnregisterTree);
    }

    bool dbusSuccess = false;

    if (cfg_DBusInstanceId != 0) {
        QString path = "/id_" + QString::number(cfg_DBusInstanceId);
        if (sessionBus.registerObject(path, QString(SERVICE_NAME),
                                      &dbusService, QDBusConnection::ExportAllSlots)) {
            dbusSuccess = true;
            dbusInstanceId = cfg_DBusInstanceId;
        }
    }

    emit dbusSuccessChanged(dbusSuccess);
}

void DoItYourselfBar::handlePassedData(QString data) {
    qDebug() << "Data passed:" << data;
}
