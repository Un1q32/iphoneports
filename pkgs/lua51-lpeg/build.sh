#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make lpeg.so \
    CC="$_TARGET-cc -I$_SDK/var/usr/include/luajit-2.1" \
    DLLFLAGS='-shared -undefined dynamic_lookup'
mkdir -p "$_DESTDIR/var/usr/lib/lua/5.1" "$_DESTDIR/var/usr/share/lua/5.1"
cp lpeg.so "$_DESTDIR/var/usr/lib/lua/5.1"
cp re.lua "$_DESTDIR/var/usr/share/lua/5.1"
)

strip_and_sign "$_DESTDIR/var/usr/lib/lua/5.1/lpeg.so"

installlicense files/LICENSE

builddeb
