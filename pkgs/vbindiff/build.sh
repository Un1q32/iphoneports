#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr
"$_TARGET-c++" -O3 -flto -o vbindiff vbindiff.cpp curses/ConWin.cpp GetOpt/GetOpt.cpp -lncurses -lpanel -Icurses
mkdir -p "$_DESTDIR/var/usr/bin"
cp vbindiff "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign vbindiff
)

builddeb
