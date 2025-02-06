#!/bin/sh -e
(
cd src || exit 1
unset TERMINFO
./configure --host="$_TARGET" --prefix=/var/usr --with-shared --enable-widec --disable-stripping --with-cxx-binding --with-cxx-shared --without-normal --without-debug --without-manpages --enable-pc-files --with-pkg-config-libdir=/var/usr/lib/pkgconfig
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/tic bin/tset bin/toe bin/clear bin/infocmp lib/libncursesw.6.dylib lib/libncurses++w.6.dylib lib/libformw.6.dylib lib/libmenuw.6.dylib lib/libpanelw.6.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/tic bin/tset bin/toe bin/clear bin/infocmp lib/libncursesw.6.dylib lib/libncurses++w.6.dylib lib/libformw.6.dylib lib/libmenuw.6.dylib lib/libpanelw.6.dylib
ln -s libncursesw.dylib lib/libtinfow.dylib
for lib in ncurses ncurses++ form menu panel tinfo; do
    ln -s "lib${lib}w.dylib" "lib/lib${lib}.dylib"
done
ln -s libncurses.dylib lib/libcurses.dylib
for pc in form menu panel ncurses ncurses++; do
    ln -s "${pc}w.pc" "lib/pkgconfig/${pc}.pc"
done
mv include/ncursesw/* include
rm -rf include/ncursesw
ln -s . include/ncurses
ln -s . include/ncursesw
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "ncurses-$_DPKGARCH.deb"
