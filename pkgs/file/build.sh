#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --prefix="$_SRCDIR/native"
make -j"$_JOBS"
make install
make clean
export PATH="$_SRCDIR/native/bin:$PATH"

if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawnp=no'
fi
./configure --host="$_TARGET" --prefix=/var/usr --enable-xzlib --enable-bzlib --enable-zlib --enable-zstdlib $posix_spawn
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/man
strip_and_sign bin/file lib/libmagic.1.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
