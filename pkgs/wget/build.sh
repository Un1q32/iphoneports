#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --with-ssl=openssl --without-zlib --disable-pcre2 --without-libpsl --disable-iri
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/wget
ldid -S"$_BSROOT/entitlements.xml" usr/bin/wget
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package wget-1.21.3.deb
