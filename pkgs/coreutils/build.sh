#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
case $_CPU in
    *64) ;;
    *) y2038='--disable-year2038' ;;
esac
autoreconf
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawn=no'
fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --enable-single-binary=symlinks \
    --with-openssl \
    $y2038 \
    $posix_spawn \
    fu_cv_sys_stat_statvfs=yes
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/coreutils libexec/coreutils/libstdbuf.so
)

installlicense "$_SRCDIR/COPYING"

builddeb
