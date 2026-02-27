#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

if [ "$_SUBSYSTEM" = "ios" ]; then
    if [ "$_OSVER" -lt 20000 ]; then
        printf 'luajit on arm requires the r9 register to be available, which is only the case on iPhone OS 3.0+\n'
        mkdir "$_DESTDIR"
        exit 0
    elif [ "$_OSVER" -lt 30000 ] && [ "$_CPU" = "armv6" ]; then
        cflags='TARGET_FLAGS=-mios-version-min=3.0'
    fi
    sys='iOS'
else
    sys='Darwin'
fi

(
cd "$_SRCDIR"
"$_TARGET-cc" -dM -E - < /dev/null | grep -q __LP64__ && arg=-m64
make amalg \
    TARGET_SYS="$sys" \
    HOST_CC="clang ${arg:--m32}" \
    CROSS="$_TARGET-" \
    BUILDMODE=dynamic \
    CCOPT=-O3 \
    PREFIX=/var/usr \
    DESTDIR="$_DESTDIR" \
    MACOSX_DEPLOYMENT_TARGET="$_MACVER" \
    $cflags
make install \
    TARGET_SYS="$sys" \
    PREFIX=/var/usr \
    DESTDIR="$_DESTDIR" \
    $cflags
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/man
ver="$(echo bin/luajit-2.1.*)"
ver="${ver#bin/luajit-2.1.}"
strip_and_sign "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib"
)

installlicense "$_SRCDIR/COPYRIGHT"

builddeb
