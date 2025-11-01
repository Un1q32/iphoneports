#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --enable-libtls-only --disable-static CFLAGS='-O3 -flto'
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf etc
chmod +x lib/libtls.*.dylib lib/libtls.la
strip_and_sign lib/libtls.*.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
