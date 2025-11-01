#!/bin/sh
. ../../files/lib.sh
mkdir -p src/build

case $_CPU in
    arm64*|aarch64*)
        cpu_family=aarch64
        asm=true
    ;;

    armv7*)
        cpu_family=arm
        asm=true
    ;;

    arm*)
        cpu_family=arm
        asm=false
    ;;

    x86_64*)
        cpu_family=x86_64
        asm=true
    ;;

    i386)
        cpu_family=x86
        asm=true
    ;;

    *)
        echo "UNSUPPORTED ARCHITECTURE"
        exit 1
    ;;
esac

sed -e "s|@CC@|$_TARGET-cc|g" \
    -e "s|@CXX@|$_TARGET-c++|g" \
    -e "s|@AR@|$_TARGET-ar|g" \
    -e "s|@RANLIB@|$_TARGET-ranlib|g" \
    -e "s|@SDK@|$_SDK|g" \
    -e "s|@CPU@|$_CPU|g" \
    -e "s|@CPU_FAMILY@|$cpu_family|g" \
    -e "s|@SUBSYSTEM@|$_SUBSYSTEM|g" \
    -e "s|@SYSROOT@|$_SDK|g" \
    -e "s|@PKGCONFIG_LIBDIR@|$_SDK/var/usr/lib/pkgconfig|g" \
    files/iphoneports.meson > src/iphoneports.meson

(
cd src/build
meson setup .. --cross-file="$_PKGROOT/src/iphoneports.meson" --prefix=/var/usr -Denable_asm="$asm" -Denable_tests=false
if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; } || { [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; }; then
    sed -i 's/-Wl,-rpath[^[:space:]]*//g' build.ninja
fi
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign bin/dav1d lib/libdav1d.7.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
