#!/bin/sh -e

cpu="${_TARGET%%-*}"

case $cpu in
    arm64*|aarch64)
        ios=
        eval "$(printf 'ios=TARGET_OS_IOS' | "$_TARGET-cc" -xc -E -)"
        if [ "$ios" = 1 ]; then
            target="ios64-cross"
        else
            target="darwin64-arm64"
        fi
    ;;

    arm*) target="ios-cross" ;;

    x86_64*) target="darwin64-x86_64" ;;

    i386) target="darwin-i386" ;;

    *)
        echo "UNSUPPORTED ARCHITECTURE"
        exit 1
    ;;
esac

(
cd src
./Configure "$target" shared --prefix=/var/usr --openssldir=/var/usr/etc/ssl --cross-compile-prefix="$_TARGET-"
"$_MAKE" CNF_CFLAGS= -j8
"$_MAKE" CNF_CFLAGS= DESTDIR="$_PKGROOT/pkg" install_sw
)

(
cd pkg/var/usr
rm -rf lib/*.a bin/c_rehash
"$_TARGET-strip" bin/openssl lib/engines-3/*.dylib lib/ossl-modules/*.dylib "$(realpath lib/libcrypto.dylib)" "$(realpath lib/libssl.dylib)" 2>/dev/null || true
ldid -S"$_ENT" bin/openssl lib/engines-3/*.dylib lib/ossl-modules/*.dylib "$(realpath lib/libcrypto.dylib)" "$(realpath lib/libssl.dylib)"
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "openssl-$_DPKGARCH.deb"
