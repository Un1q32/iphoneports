#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-telnet --enable-utmp
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
mkdir -p "$_DESTDIR/var/usr/etc"
cp etc/etcscreenrc "$_DESTDIR/var/usr/etc/screenrc"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/info share/man
strip_and_sign bin/screen-*
)

installlicense "$_SRCDIR/COPYING"

builddeb
