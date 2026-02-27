#!/bin/sh
. ../../files/lib.sh

if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_OSVER" -lt 1050 ]; }; then
    printf 'htop requires libproc, which is present on Mac OS X 10.5+ and iPhone OS 2.0+\n'
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-unicode --disable-linux-affinity
make
mkdir -p "$_DESTDIR/var/usr/bin"
cp htop "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/htop"

installlicense "$_SRCDIR/COPYING"

builddeb
