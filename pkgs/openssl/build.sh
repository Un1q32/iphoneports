#!/bin/sh
# shellcheck disable=2086
set -e
. ../../files/lib.sh

(
cd src

case $_CPU in
    (arm64)
        if [ "$_SUBSYSTEM" = "ios" ]; then
            sys=ios64-cross
        else
            sys=darwin64-arm64
        fi
    ;;
    (arm*)
        sys=ios-cross
        noasm=no-asm
    ;;
    (i386)
        sys=darwin-i386
    ;;
    (x86_64)
        sys=darwin64-x86_64
    ;;
esac

./Configure "$sys" $noasm --prefix=/var/usr --openssldir=/var/usr/etc/ssl CROSS_COMPILE="$_TARGET"-
"$_MAKE" CNF_CFLAGS= PROGRAMS=apps/openssl -j"$_JOBS"
"$_MAKE" CNF_CFLAGS= PROGRAMS=apps/openssl DESTDIR="$_PKGROOT/pkg" install_sw install_ssldirs
)

(
cd pkg/var/usr
rm -rf bin/c_rehash lib/*.a etc/ssl/misc
for bin in bin/* lib/*.dylib lib/*/*.dylib; do
    [ -h "$bin" ] || strip_and_sign "$bin"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.txt "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
