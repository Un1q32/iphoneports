#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-cxx --disable-static --disable-doc
make DESTDIR="$_DESTDIR" install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
abi=4
lib="$(realpath lib/libmpdec.$abi.dylib)"
install_name_tool -id /var/usr/lib/libmpdec.$abi.dylib "$lib"
strip_and_sign "$lib"
)

installlicense src/COPYRIGHT.txt

builddeb
