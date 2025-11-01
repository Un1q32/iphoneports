#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make PREFIX="$_DESTDIR/var/usr" CC="$_TARGET-cc" CFLAGS="-Os -flto -std=c99" install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf man
strip_and_sign bin/tree
)

installlicense "$_SRCDIR/LICENSE"

builddeb
