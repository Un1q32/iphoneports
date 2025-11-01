#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    ipv6='--disable-ipv6'
else
    ipv6='--enable-ipv6'
fi
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl --with-brotli --with-zlib $ipv6
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

rm -rf "$_DESTDIR/var/usr/share"
strip_and_sign "$_DESTDIR/var/usr/bin/lynx"

installlicense "$_SRCDIR/COPYING"

builddeb
