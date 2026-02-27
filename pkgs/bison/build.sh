#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawn=no'
fi
./configure --host="$_TARGET" --prefix=/var/usr $posix_spawn
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/doc share/info share/man
strip_and_sign bin/bison
)

installlicense "$_SRCDIR/COPYING"

builddeb
