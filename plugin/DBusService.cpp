#include "DBusService.hpp"

DBusService::DBusService(QObject* parent) : QObject(parent) {
}

void DBusService::pass(QString data) {
    emit dataPassed(data);
}
