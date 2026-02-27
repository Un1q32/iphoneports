#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; then
    posix_spawn='--disable-posix-spawn'
fi
./configure --host="$_TARGET" --prefix=/var/usr $posix_spawn
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/make
)

installlicense "$_SRCDIR/COPYING"

builddeb
