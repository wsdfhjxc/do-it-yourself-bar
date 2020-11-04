function delay(milliseconds, callbackFunc) {
    var timer = Qt.createQmlObject("import QtQuick 2.7; Timer {}", root);
    timer.interval = milliseconds;
    timer.repeat = false;
    timer.triggered.connect(callbackFunc);
    timer.start();
    return timer;
}
