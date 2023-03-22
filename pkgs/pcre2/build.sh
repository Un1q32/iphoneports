#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --disable-static --enable-pcre2grep-libbz2 --enable-pcre2grep-libz --enable-pcre2test-libreadline
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-install_name_tool" -change libbz2.dylib /usr/local/lib/libbz2.1.dylib usr/bin/pcre2grep
"$_TARGET-strip" usr/bin/pcre2test > /dev/null 2>1
"$_TARGET-strip" usr/bin/pcre2grep > /dev/null 2>1
"$_TARGET-strip" usr/lib/libpcre2-8.0.dylib > /dev/null 2>1
"$_TARGET-strip" usr/lib/libpcre2-posix.3.dylib > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/pcre2test
ldid -S"$_BSROOT/entitlements.xml" usr/bin/pcre2grep
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libpcre2-8.0.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libpcre2-posix.3.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package pcre2-10.42.deb
