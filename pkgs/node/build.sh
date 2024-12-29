#!/bin/sh

cpu="${_TARGET%%-*}"

case $cpu in
    arm64|arm64e|aarch64)
        cpu=arm64
        mac= # shut up shellcheck
        eval "$(echo "mac=TARGET_OS_MAC" | "$_TARGET-cc" -E -xc -)"
        if [ "$mac" = 1 ]; then
            os=mac
        else
            os=ios
        fi
    ;;

    arm*)
        os=ios
        cpu=arm
    ;;

    x86_64|x86_64h)
        os=mac
        cpu=x86_64
    ;;

    i386|i686)
        os=mac
        cpu=x32
    ;;

    *)
        echo "UNSUPPORTED ARCHITECTURE"
        exit 1
    ;;
esac

(
cd src || exit 1
CC="$_TARGET-cc" CXX="$_TARGET-c++ -std=gnu++20" SDKROOT="$_SDK" PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" ./configure --prefix=/var/usr --cross-compiling --dest-os="$os" --dest-cpu="$cpu" --without-npm --shared --shared-zlib --shared-libuv --shared-brotli --shared-nghttp2 --shared-nghttp3 --shared-ngtcp2 --shared-openssl --shared-cares --shared-sqlite --openssl-use-def-ca-store --download=all
"$_MAKE" install -j8 DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
# rm -rf share
# "$_TARGET-strip" bin/* 2>/dev/null
# ldid -S"$_ENT" bin/*
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg node.deb
