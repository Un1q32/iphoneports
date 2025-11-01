#!/bin/sh
. ../../files/lib.sh

(
cd src

case $_CPU in
    (arm64*) cpu=aarch64 ;;
    (arm*)   cpu=arm     ;;
    (*)      cpu=$_CPU   ;;
esac

cp "src/syscfg/lock-obj-pub.$cpu-apple-darwin.h" src/syscfg/lock-obj-pub.cross-os.h

./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-nls --disable-doc --disable-tests --enable-silent-rules
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/common-lisp
strip_and_sign bin/gpg-error lib/libgpg-error.0.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
