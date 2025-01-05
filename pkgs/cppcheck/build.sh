#!/bin/sh
(
cd src || exit 1
"$_MAKE" install CXX="$_TARGET-c++" PREFIX=/var/usr FILESDIR=/var/usr/share/cppcheck DESTDIR="$_PKGROOT/pkg" HAVE_RULES=yes uname_S=Darwin -j"$_JOBS"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" cppcheck 2>/dev/null
ldid -S"$_ENT" cppcheck
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg cppcheck.deb
