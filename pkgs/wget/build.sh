#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --with-ssl=openssl --without-zlib --disable-pcre2 --without-libpsl --disable-iri
make -j4
make DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/wget
ldid -S"$_BSROOT/entitlements.plist" usr/bin/wget
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package wget-1.21.3.deb
