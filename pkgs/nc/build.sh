#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --enable-libtls-only \
    --disable-static \
    --enable-nc
make -j"$_JOBS" install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf etc share include lib
strip_and_sign bin/nc
mkdir -p share/licenses
ln -s libtls share/licenses/nc
)

builddeb
