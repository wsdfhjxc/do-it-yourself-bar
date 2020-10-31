#pragma once

#include <QObject>
#include <QString>

#define SERVICE_NAME "org.kde.plasma.doityourselfbar"

class DBusService : public QObject {
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", SERVICE_NAME)

public:
    DBusService(QObject* parent = nullptr);

public slots:
    void pass(QString data);

signals:
    void dataPassed(QString data);
};
