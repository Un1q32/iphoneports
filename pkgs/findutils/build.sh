#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
case $_CPU in
    *64) ;;
    *) y2038='--disable-year2038' ;;
esac
./configure --host="$_TARGET" --prefix=/var/usr $y2038
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share var
strip_and_sign bin/find bin/xargs bin/locate libexec/frcode
)

installlicense "$_SRCDIR/COPYING"

builddeb
