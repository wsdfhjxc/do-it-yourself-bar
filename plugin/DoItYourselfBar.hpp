#pragma once

#include <QObject>
#include <QVariantList>

#include "DBusService.hpp"

class DoItYourselfBar : public QObject {
    Q_OBJECT

public:
    DoItYourselfBar(QObject* parent = nullptr);

    Q_PROPERTY(unsigned cfg_DBusInstanceId
               MEMBER cfg_DBusInstanceId
               NOTIFY cfg_DBusInstanceIdChanged)

    void cfg_DBusInstanceIdChanged();

signals:
    void dbusSuccessChanged(bool dbusSuccess);
    void invalidDataFormatDetected();
    void blockInfoListSent(QVariantList blockInfoList);

private:
    DBusService dbusService;
    unsigned dbusInstanceId;

    unsigned cfg_DBusInstanceId;

    void handlePassedData(QString data);
};
