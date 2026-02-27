#!/bin/sh
. ../../files/lib.sh
# shellcheck disable=2086
(
cd "$_SRCDIR"
case $_CPU in
    arm64*) ;;
    arm*) disableasm='--disable-assembly' ;;
esac
./configure --host="$_TARGET" --prefix=/var/usr --disable-static $disableasm
make
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign lib/libgmp.10.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
