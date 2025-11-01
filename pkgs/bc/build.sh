#!/bin/sh
. ../../files/lib.sh

(
cd src
CC="$_TARGET-cc" HOSTCC=cc ./configure --prefix=/var/usr --enable-readline --disable-nls --disable-strip --disable-man-pages
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign "$_DESTDIR/var/usr/bin/bc"

installlicense "$_SRCDIR/LICENSE.md"

builddeb
