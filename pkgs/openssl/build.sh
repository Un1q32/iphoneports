#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"

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
    (x86_64*)
        sys=darwin64-x86_64
    ;;

    (*)
        echo "UNSUPPORTED ARCHITECTURE"
        exit 1
    ;;
esac

./Configure "$sys" $noasm --prefix=/var/usr --openssldir=/var/usr/etc/ssl CROSS_COMPILE="$_TARGET"-
make CNF_CFLAGS= PROGRAMS=apps/openssl -j"$_JOBS"
make CNF_CFLAGS= PROGRAMS=apps/openssl DESTDIR="$_DESTDIR" install_sw install_ssldirs
)

(
cd "$_DESTDIR/var/usr"
rm -rf bin/c_rehash lib/*.a etc/ssl/misc
for bin in bin/* lib/*.dylib lib/*/*.dylib; do
    [ -h "$bin" ] || strip_and_sign "$bin"
done
)

installlicense "$_SRCDIR/LICENSE.txt"

builddeb
