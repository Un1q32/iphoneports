#!/bin/sh
set -e
. ../../files/lib.sh

# hack to make ripgrep not include the iphoneports git rev
mkdir -p "$_PKGROOT/src/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_PKGROOT/src/iphoneports-fakebin/git"
chmod +x "$_PKGROOT/src/iphoneports-fakebin/git"
export PATH="$_PKGROOT/src/iphoneports-fakebin:$PATH"

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
    cargo build --target "$_RUSTTARGET" --release --features 'pcre2' -j "$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp "target/$_RUSTTARGET/release/rg" "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/rg

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/UNLICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
