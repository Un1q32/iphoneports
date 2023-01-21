#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm usr/bin/gawk-5.2.1
rm usr/bin/gawkbug
rm -rf usr/share/info
rm -rf usr/share/man
"$_TARGET-strip" -x usr/bin/gawk
"$_TARGET-strip" -x usr/lib/gawk/*
"$_TARGET-strip" -x usr/libexec/awk/*
ldid -S"$_BSROOT/entitlements.xml" usr/bin/gawk
ldid -S"$_BSROOT/entitlements.xml" usr/lib/gawk/*
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/awk/*
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package gawk-5.2.1.deb
