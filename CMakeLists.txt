cmake_minimum_required(VERSION 3.0)
project(DoItYourselfBar)

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

if(NOT CMAKE_INSTALL_PREFIX)
    set(CMAKE_INSTALL_PREFIX "/usr")
endif()

file(STRINGS /etc/os-release distro REGEX "^NAME=.*$")
if(distro MATCHES ".*openSUSE.*")
    set(QML_INSTALL_DIR "/usr/lib64/qt5/qml")
endif()

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)
include(ECMInstallIcons)

set(REQUIRED_QT_VERSION 5.9.5)
set(KF5_MIN_VERSION 5.44.0)

find_package(Qt5 ${REQUIRED_QT_VERSION}
             CONFIG REQUIRED
             Qml
             DBus)

find_package(KF5 ${KF5_MIN_VERSION}
             REQUIRED COMPONENTS
             Plasma)

plasma_install_package(package org.kde.plasma.doityourselfbar)

set(doityourselfbar_SRCS
    plugin/BlockInfo.cpp
    plugin/DBusService.cpp
    plugin/DoItYourselfBar.cpp
    plugin/DoItYourselfBarPlugin.cpp
)

add_library(doityourselfbar SHARED ${doityourselfbar_SRCS})

target_link_libraries(doityourselfbar
                      Qt5::Qml
                      Qt5::DBus
                      KF5::Plasma)

install(TARGETS doityourselfbar DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/doityourselfbar)
install(FILES plugin/qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/doityourselfbar)

ecm_install_icons(ICONS icons/sc-apps-doityourselfbar.svg DESTINATION ${ICON_INSTALL_DIR})
