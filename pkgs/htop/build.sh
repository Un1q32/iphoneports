#!/bin/sh
. ../../files/lib.sh

if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; }; then
    printf 'htop requires libproc, which is present on Mac OS X 10.5+ and iPhone OS 2.0+\n'
    mkdir pkg
    exit 0
fi

(
cd src
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-unicode --disable-linux-affinity
make -j"$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp htop "$_DESTDIR/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/htop

installlicense "$_SRCDIR/COPYING"

builddeb
