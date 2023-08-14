#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-utf --disable-static --enable-pcretest-libreadline --enable-pcregrep-libbz2 --enable-pcregrep-libz
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/pcretest > /dev/null 2>&1
"$_TARGET-strip" bin/pcregrep > /dev/null 2>&1
"$_TARGET-strip" lib/libpcre.1.dylib > /dev/null 2>&1
"$_TARGET-strip" lib/libpcrecpp.0.dylib > /dev/null 2>&1
"$_TARGET-strip" lib/libpcreposix.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/pcretest
ldid -S"$_BSROOT/ent.xml" bin/pcregrep
ldid -S"$_BSROOT/ent.xml" lib/libpcre.1.dylib
ldid -S"$_BSROOT/ent.xml" lib/libpcrecpp.0.dylib
ldid -S"$_BSROOT/ent.xml" lib/libpcreposix.0.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pcre.deb
