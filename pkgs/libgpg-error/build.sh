#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"

case $_CPU in
    (arm64*)        cpu=aarch64 ;;
    (arm*)          cpu=arm     ;;
    (ppc*|powerpc*) cpu=i386    ;;
    (x86_64*)       cpu=x86_64  ;;
    (*)
        printf 'Unknown architecture\n'
        exit 1
    ;;
esac

cp "src/syscfg/lock-obj-pub.$cpu-apple-darwin.h" src/syscfg/lock-obj-pub.cross-os.h

./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-nls --disable-doc --disable-tests --enable-silent-rules
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/common-lisp
strip_and_sign bin/gpg-error lib/libgpg-error.0.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
