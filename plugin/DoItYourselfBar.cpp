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

    bool dbusSuccess = cfg_DBusInstanceId != 0;

    if (cfg_DBusInstanceId != 0) {
        dbusInstanceId = cfg_DBusInstanceId;
        QString path = "/id_" + QString::number(dbusInstanceId);
        dbusSuccess = sessionBus.registerObject(path, QString(SERVICE_NAME),
                                                    &dbusService, QDBusConnection::ExportAllSlots);
    }

    emit dbusSuccessChanged(dbusSuccess);
}

void DoItYourselfBar::handlePassedData(QString data) {
    qDebug() << "Data passed:" << data;
}
