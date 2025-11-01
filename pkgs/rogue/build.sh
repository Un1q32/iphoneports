#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-scorefile=/var/usr/share/rogue/scores --enable-setgid
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/doc share/man
strip_and_sign bin/rogue
chmod 2755 bin/rogue
)

installsuid "$_DESTDIR/var/usr/bin/rogue"

installlicense src/LICENSE.TXT

builddeb
