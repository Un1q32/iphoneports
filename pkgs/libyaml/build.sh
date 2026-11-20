#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-silent-rules
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign lib/libyaml-*.dylib
)

installlicense "$_SRCDIR/License"

builddeb
