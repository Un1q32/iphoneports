#!/bin/sh

mkdir -p pkg/var/usr/share/httpiss pkg/Library/LaunchAgents
cp files/squid.conf pkg/var/usr/share/httpiss
cp files/com.iphoneports.httpiss.plist pkg/Library/LaunchAgents

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg httpiss.deb
