#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --libdir=/usr/local/lib --disable-static --without-python --with-zlib --with-lzma
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/doc usr/share/gtk-doc usr/share/man
"$_TARGET-strip" usr/bin/xmlcatalog > /dev/null 2>&1
"$_TARGET-strip" usr/bin/xmllint > /dev/null 2>&1
"$_TARGET-strip" usr/local/lib/libxml2.2.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/xmlcatalog
ldid -S"$_BSROOT/entitlements.xml" usr/bin/xmllint
ldid -S"$_BSROOT/entitlements.xml" usr/local/lib/libxml2.2.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libxml2.deb
