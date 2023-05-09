#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --enable-utf --disable-static --enable-pcretest-libreadline --enable-pcregrep-libbz2 --enable-pcregrep-libz
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/pcretest > /dev/null 2>&1
"$_TARGET-strip" usr/bin/pcregrep > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libpcre.1.dylib > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libpcrecpp.0.dylib > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libpcreposix.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/pcretest
ldid -S"$_BSROOT/ent.xml" usr/bin/pcregrep
ldid -S"$_BSROOT/ent.xml" usr/lib/libpcre.1.dylib
ldid -S"$_BSROOT/ent.xml" usr/lib/libpcrecpp.0.dylib
ldid -S"$_BSROOT/ent.xml" usr/lib/libpcreposix.0.dylib
ln -s libpcre.1.dylib usr/lib/libpcre.0.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package pcre.deb
