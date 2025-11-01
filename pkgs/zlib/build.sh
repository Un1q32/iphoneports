#!/bin/sh
. ../../files/lib.sh

(
cd src
CHOST="$_TARGET" ./configure --prefix=/var/usr --zlib-compat --force-sse2
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share lib/libz.a
for lib in lib/*.dylib; do
    if [ -f "$lib" ] && [ ! -h "$lib" ]; then
        install_name_tool -id /var/usr/lib/libz.1.dylib "$lib"
        strip_and_sign "$lib"
    fi
done
)

installlicense "$_SRCDIR/LICENSE.md"

builddeb
