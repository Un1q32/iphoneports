#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --with-shell=/var/usr/bin/sh --enable-silent-rules PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

rm -rf pkg/var/usr/share
strip_and_sign pkg/var/usr/bin/ncdu

installlicense "$_SRCDIR/COPYING"

builddeb
