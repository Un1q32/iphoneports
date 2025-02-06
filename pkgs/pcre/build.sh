#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-utf --disable-static --enable-pcretest-libreadline --enable-pcregrep-libbz2 --enable-pcregrep-libz
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/pcretest bin/pcregrep lib/libpcre.1.dylib lib/libpcrecpp.0.dylib lib/libpcreposix.0.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/pcretest bin/pcregrep lib/libpcre.1.dylib lib/libpcrecpp.0.dylib lib/libpcreposix.0.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "pcre-$_DPKGARCH.deb"
