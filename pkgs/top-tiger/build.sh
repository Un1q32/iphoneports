#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

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
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp top "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign top
chmod 4755 top
)

mkdir -p pkg/usr/local/libexec/iphoneports
mv pkg/var/usr/bin/top pkg/usr/local/libexec/iphoneports/top
ln -s ../../../../usr/local/libexec/iphoneports/top pkg/var/usr/bin/top

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
