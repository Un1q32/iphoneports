#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-single-binary=symlinks --with-openssl ac_year2038_required=no
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/coreutils > /dev/null 2>&1
"$_TARGET-strip" libexec/coreutils/libstdbuf.so > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/coreutils
ldid -S"$_BSROOT/ent.xml" libexec/coreutils/libstdbuf.so
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg coreutils.deb
