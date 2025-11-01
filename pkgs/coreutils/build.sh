#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd src
case $_CPU in
    *64) ;;
    *) y2038='--disable-year2038' ;;
esac
autoreconf
./configure --host="$_TARGET" --prefix=/var/usr --enable-single-binary=symlinks --with-openssl $y2038 fu_cv_sys_stat_statvfs=yes
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/coreutils libexec/coreutils/libstdbuf.so
)

installlicense "$_SRCDIR/COPYING"

builddeb
