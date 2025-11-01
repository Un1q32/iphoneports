#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
mkdir -p "$_DESTDIR/var/usr/bin"
"$_TARGET-cc" -Os -flto -o gzip gzip.c -lz -lbz2 -llzma -DGZIP_APPLE_VERSION='"448.0.3"' -D'__FBSDID(x)='
for prog in gzip gzexe zdiff zforce zmore znew; do
    cp "$prog" "$_DESTDIR/var/usr/bin"
    chmod 755 "$_DESTDIR/var/usr/bin/$prog"
done
)

(
cd "$_DESTDIR/var/usr/bin"
strip_and_sign gzip
for link in gunzip gzcat zgrep zegrep zfgrep; do
    ln -s gzip "$link"
done
ln -s zdiff zcmp
ln -s zmore zless
)

installlicense files/LICENSE

builddeb
