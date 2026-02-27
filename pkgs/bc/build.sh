#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
CC="$_TARGET-cc" HOSTCC=cc ./configure --prefix=/var/usr --enable-readline --disable-nls --disable-strip --disable-man-pages
make
make DESTDIR="$_DESTDIR" install
)

strip_and_sign "$_DESTDIR/var/usr/bin/bc"

installlicense "$_SRCDIR/LICENSE.md"

builddeb
