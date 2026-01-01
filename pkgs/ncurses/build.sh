#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
unset TERMINFO
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-shared \
    --enable-widec \
    --disable-stripping \
    --without-cxx \
    --without-normal \
    --without-debug \
    --without-manpages \
    --enable-pc-files \
    --with-pkg-config-libdir=/var/usr/lib/pkgconfig
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign \
    bin/tabs \
    bin/tput \
    bin/tic \
    bin/tset \
    bin/toe \
    bin/clear \
    bin/infocmp \
    lib/libncursesw.6.dylib \
    lib/libformw.6.dylib \
    lib/libmenuw.6.dylib \
    lib/libpanelw.6.dylib
ln -s libncursesw.dylib lib/libtinfow.dylib
ln -s libncurses.dylib lib/libtinfo.dylib
ln -s libncurses.dylib lib/libcurses.dylib
for lib in ncurses form menu panel; do
    ln -s "lib${lib}w.dylib" "lib/lib${lib}.dylib"
    ln -s "${lib}w.pc" "lib/pkgconfig/${lib}.pc"
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

installlicense "$_SRCDIR/COPYING"

builddeb
