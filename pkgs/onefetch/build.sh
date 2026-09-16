#!/bin/sh
. ../../files/lib.sh

if ! supportsrust; then
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
SDKROOT="$_SDK" \
    TARGET_PKG_CONFIG=pkg-config \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK" \
    ZSTD_SYS_USE_PKG_CONFIG=1 \
    cargo build --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp "target/$_RUSTTARGET/release/onefetch" "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/onefetch"

installlicense "$_SRCDIR/LICENSE.md"

builddeb
