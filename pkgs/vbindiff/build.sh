#!/bin/sh
. ../../files/lib.sh
(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr
"$_TARGET-c++" -O3 -flto -o vbindiff vbindiff.cpp curses/ConWin.cpp GetOpt/GetOpt.cpp -lncurses -lpanel -Icurses
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vbindiff "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign vbindiff
)

builddeb
