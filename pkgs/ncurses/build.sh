#!/bin/sh
(
cd src || exit 1
unset TERMINFO
./configure --host="$_TARGET" --prefix=/var/usr --with-shared --enable-widec --disable-stripping --with-cxx-binding --with-cxx-shared --without-normal --without-debug
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
"$_TARGET-strip" bin/tic bin/tset bin/toe bin/clear bin/infocmp lib/libncursesw.6.dylib lib/libncurses++w.6.dylib lib/libformw.6.dylib lib/libmenuw.6.dylib lib/libpanelw.6.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/tic bin/tset bin/toe bin/clear bin/infocmp lib/libncursesw.6.dylib lib/libncurses++w.6.dylib lib/libformw.6.dylib lib/libmenuw.6.dylib lib/libpanelw.6.dylib
for lib in ncurses ncurses++ form menu panel; do
    ln -s "lib${lib}w.dylib" "lib/lib${lib}.dylib"
done
ln -s libncurses.dylib lib/libcurses.dylib
for header in include/ncursesw/*.h; do
    ln -s "${header#include/}" include/"${header#include/ncursesw/}"
done
ln -s ncursesw include/ncurses
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncurses.deb
