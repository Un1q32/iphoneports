#!/bin/sh
# shellcheck disable=2086
set -e
. ../../files/lib.sh

(
cd src
case $_CPU in
    *64) ;;
    *) y2038='--disable-year2038' ;;
esac
autoreconf
./configure --host="$_TARGET" --prefix=/var/usr --enable-single-binary=symlinks --with-openssl $y2038 fu_cv_sys_stat_statvfs=yes
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/coreutils libexec/coreutils/libstdbuf.so
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
