#pragma once

#include <QObject>

#include "DBusService.hpp"

class DoItYourselfBar : public QObject {
    Q_OBJECT

public:
    DoItYourselfBar(QObject* parent = nullptr);

    Q_PROPERTY(bool dbusError
               MEMBER dbusError);

    Q_PROPERTY(unsigned cfg_DBusInstanceId
               MEMBER cfg_DBusInstanceId
               NOTIFY cfg_DBusInstanceIdChanged)

    void cfg_DBusInstanceIdChanged();

private:
    DBusService dbusService;
    unsigned dbusInstanceId;

    bool dbusError;
    unsigned cfg_DBusInstanceId;

    void handlePassedData(QString data);
};
