#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr/bin"
rm -rf ../share
strip_and_sign bsdcat bsdcpio bsdtar bsdunzip ../lib/libarchive.13.dylib
for prog in tar cpio unzip; do
    ln -s "bsd$prog" "$prog"
done
)

installlicense "$_SRCDIR/COPYING"

builddeb
