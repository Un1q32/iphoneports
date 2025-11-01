#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make CXX="$_TARGET-c++" STRIP=true CXXFLAGS="-O3 -flto -Wno-dangling-else -Wno-switch" LIBFLAGS= -j"$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp unrar "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/unrar"

installlicense src/license.txt

builddeb
