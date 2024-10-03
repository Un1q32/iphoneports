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
"$_TARGET-strip" bin/pcre2test bin/pcre2grep lib/libpcre2-8.0.dylib lib/libpcre2-posix.3.dylib 2>/dev/null
ldid -S"$_ENT" bin/pcre2test bin/pcre2grep lib/libpcre2-8.0.dylib lib/libpcre2-posix.3.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pcre2.deb
