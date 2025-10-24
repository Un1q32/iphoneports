#!/bin/sh
. ../../files/lib.sh

(
cd src
unset TERMINFO
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-shared \
    --enable-widec \
    --disable-stripping \
    --with-cxx-binding \
    --with-cxx-shared \
    --without-normal \
    --without-debug \
    --without-manpages \
    --enable-pc-files \
    --with-pkg-config-libdir=/var/usr/lib/pkgconfig
make -j"$_JOBS"
make DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
strip_and_sign \
    bin/tabs \
    bin/tput \
    bin/tic \
    bin/tset \
    bin/toe \
    bin/clear \
    bin/infocmp \
    lib/libncursesw.6.dylib \
    lib/libncurses++w.6.dylib \
    lib/libformw.6.dylib \
    lib/libmenuw.6.dylib \
    lib/libpanelw.6.dylib
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
cd share/terminfo
for ti in */*; do
    case "$ti" in
        (*ansi*|*cons25*|*cygwin*|*dumb*|*linux*|*mach*|*rxvt*|*screen*|*sun*|*vt52*|*vt100*|*vt102*|*vt220*|*swvt25*|*xterm*|*putty*|*konsole*|*gnome*|*apple*|*Apple_Terminal*|*unknown*) ;;
        (*) rm "$ti" ;;
    esac
done
find . -type d -empty -delete
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
