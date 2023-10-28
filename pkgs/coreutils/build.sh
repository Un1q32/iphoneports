#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-single-binary=symlinks --with-openssl --disable-year2038 fu_cv_sys_stat_statvfs=yes
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/coreutils libexec/coreutils/libstdbuf.so > /dev/null 2>&1
ldid -S"$_ENT" bin/coreutils libexec/coreutils/libstdbuf.so
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg coreutils.deb
