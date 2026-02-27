#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
case $_CPU in
    *64) ;;
    *) y2038='--disable-year2038' ;;
esac
./configure --host="$_TARGET" --prefix=/var/usr $y2038
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/patch
)

installlicense "$_SRCDIR/COPYING"

builddeb
