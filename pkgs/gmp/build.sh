#!/bin/sh
. ../../files/lib.sh
# shellcheck disable=2086
(
cd src
case $_CPU in
    arm64*) ;;
    arm*) disableasm='--disable-assembly' ;;
esac
./configure --host="$_TARGET" --prefix=/var/usr --disable-static $disableasm
make -j"$_JOBS"
make install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign lib/libgmp.10.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
