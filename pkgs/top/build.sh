#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

if [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; then
    printf 'top requires at least Mac OS X 10.5\n'
    mkdir pkg
    exit 0
fi

(
cd src
if [ -f "$_SDK/usr/lib/libutil.dylib" ] || [ -f "$_SDK/usr/lib/libutil.tbd" ]; then
    libutil="$_PKGROOT/files/humanize_number.c"
else
    libutil="-lutil"
fi
"$_TARGET-cc" \
    -Os -flto \
    top.c \
    libtop.c \
    log.c \
    samp.c \
    disp.c \
    ch.c \
    dch.c \
    -o top \
    -DTOP_DEPRECATED \
    -w \
    -lncurses \
    -lpanel \
    -framework IOKit \
    -framework CoreFoundation \
    $libutil
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp top "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign top
chmod 4755 top
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/top pkg/usr/libexec/iphoneports/top
ln -s ../../../../usr/libexec/iphoneports/top pkg/var/usr/bin/top

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"
if [ -f "$_SDK/usr/lib/libutil.dylib" ] || [ -f "$_SDK/usr/lib/libutil.tbd" ]; then
    cp files/LICENSE-LIBBSD "pkg/var/usr/share/licenses/$_PKGNAME"
fi

builddeb
