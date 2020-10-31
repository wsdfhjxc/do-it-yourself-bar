#include "DoItYourselfBarPlugin.hpp"

#include <QQmlEngine>

#include "DoItYourselfBar.hpp"

void DoItYourselfBarPlugin::registerTypes(const char* uri) {
    qmlRegisterType<DoItYourselfBar>(uri, 1, 0, "DoItYourselfBar");
}
