#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

if { [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -ge 1050 ]; } ||
    [ "$_SUBSYSTEM" != "macos" ]; then
    printf 'top-tiger is only for Mac OS X 10.4\n'
    mkdir pkg
    exit 0
fi

(
cd src
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
    -Wno-incompatible-function-pointer-types \
    -Wno-int-conversion
mkdir -p "$_DESTDIR/var/usr/bin"
cp top "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/top"
chmod 4755 "$_DESTDIR/var/usr/bin/top"

installsuid "$_DESTDIR/var/usr/bin/top"

installlicense files/LICENSE

builddeb
