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
mkdir -p "$_DESTDIR/var/usr/bin"
cp top "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign top
chmod 4755 top
)

mkdir -p pkg/usr/local/libexec/iphoneports
mv pkg/var/usr/bin/top pkg/usr/local/libexec/iphoneports/top
ln -s ../../../../usr/local/libexec/iphoneports/top pkg/var/usr/bin/top

installlicense files/LICENSE
if [ -f "$_SDK/usr/lib/libutil.dylib" ] || [ -f "$_SDK/usr/lib/libutil.tbd" ]; then
    installlicense files/LICENSE-LIBBSD
fi

builddeb
