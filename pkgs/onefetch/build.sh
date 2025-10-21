#!/bin/sh
. ../../files/lib.sh

if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; }; then
    printf 'Rust requires at least Mac OS X 10.5 or iPhone OS 2.0\n'
    mkdir pkg
    exit 0
fi

(
cd src
SDKROOT="$_SDK" \
    TARGET_PKG_CONFIG=pkg-config \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK" \
    ZSTD_SYS_USE_PKG_CONFIG=1 \
    cargo build --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp "target/$_RUSTTARGET/release/onefetch" "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/onefetch

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.md "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
