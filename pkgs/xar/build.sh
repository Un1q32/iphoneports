#!/bin/sh -e
(
cd src/xar
ln -s . include/xar
./configure --host="$_TARGET" --prefix=/var/usr --with-xml2-config="$_SDK/var/usr/bin/xml2-config" --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" LIBS=-lcrypto CPPFLAGS=-Ilib
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/xar lib/libxar.1.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/xar lib/libxar.1.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "xar-$_DPKGARCH.deb"
