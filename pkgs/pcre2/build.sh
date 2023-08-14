#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-pcre2grep-libbz2 --enable-pcre2grep-libz --enable-pcre2test-libreadline
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/pcre2test > /dev/null 2>&1
"$_TARGET-strip" bin/pcre2grep > /dev/null 2>&1
"$_TARGET-strip" lib/libpcre2-8.0.dylib > /dev/null 2>&1
"$_TARGET-strip" lib/libpcre2-posix.3.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/pcre2test
ldid -S"$_BSROOT/ent.xml" bin/pcre2grep
ldid -S"$_BSROOT/ent.xml" lib/libpcre2-8.0.dylib
ldid -S"$_BSROOT/ent.xml" lib/libpcre2-posix.3.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pcre2.deb
