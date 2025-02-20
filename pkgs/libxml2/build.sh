#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-python --with-zlib --with-lzma PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/doc share/gtk-doc share/man
ln -s libxml2/libxml include/libxml
"$_TARGET-strip" bin/xmlcatalog bin/xmllint lib/libxml2.2.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/xmlcatalog bin/xmllint lib/libxml2.2.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "libxml2-$_DPKGARCH.deb"
