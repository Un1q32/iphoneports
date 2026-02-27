#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --with-shell=/var/usr/bin/sh --enable-silent-rules PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make
make DESTDIR="$_DESTDIR" install
)

rm -rf "$_DESTDIR/var/usr/share"
strip_and_sign "$_DESTDIR/var/usr/bin/ncdu"

installlicense "$_SRCDIR/COPYING"

builddeb
