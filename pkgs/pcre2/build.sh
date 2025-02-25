#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-pcre2grep-libbz2 --enable-pcre2grep-libz --enable-pcre2test-libreadline --enable-pcre2-16 --enable-pcre2-32
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/pcre2test bin/pcre2grep lib/libpcre2-8.0.dylib lib/libpcre2-16.0.dylib lib/libpcre2-32.0.dylib lib/libpcre2-posix.3.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/pcre2test bin/pcre2grep lib/libpcre2-8.0.dylib lib/libpcre2-16.0.dylib lib/libpcre2-32.0.dylib lib/libpcre2-posix.3.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
