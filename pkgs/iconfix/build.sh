#!/bin/sh
mkdir -p package/usr/bin
"$_CP" source/iconfix.sh package/usr/bin/iconfix

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package iconfix-5.1.deb
