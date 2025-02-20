#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-single-binary=symlinks --with-openssl --disable-year2038 fu_cv_sys_stat_statvfs=yes
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/coreutils libexec/coreutils/libstdbuf.so 2>/dev/null || true
ldid -S"$_ENT" bin/coreutils libexec/coreutils/libstdbuf.so
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "coreutils-$_CPU-$_SUBSYSTEM.deb"
