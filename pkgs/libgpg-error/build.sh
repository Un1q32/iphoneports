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
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/common-lisp
strip_and_sign bin/gpg-error lib/libgpg-error.0.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
