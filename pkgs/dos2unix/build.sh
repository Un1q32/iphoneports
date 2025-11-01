#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make CC="$_TARGET-cc" STRIP=true CPP="$_TARGET-cc -E" DESTDIR="$_DESTDIR" prefix=/var/usr ENABLE_NLS= install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/dos2unix bin/unix2dos
)

installlicense "$_SRCDIR/COPYING.txt"

builddeb
