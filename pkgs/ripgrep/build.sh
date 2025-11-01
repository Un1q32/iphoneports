#!/bin/sh
. ../../files/lib.sh

# hack to make ripgrep not include the iphoneports git rev
mkdir -p "$_SRCDIR/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_SRCDIR/iphoneports-fakebin/git"
chmod +x "$_SRCDIR/iphoneports-fakebin/git"
export PATH="$_SRCDIR/iphoneports-fakebin:$PATH"

if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; }; then
    printf 'Rust requires at least Mac OS X 10.5 or iPhone OS 2.0\n'
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
SDKROOT="$_SDK" \
    TARGET_PKG_CONFIG=pkg-config \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK" \
    cargo build --target "$_RUSTTARGET" --release --features 'pcre2' -j "$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp "target/$_RUSTTARGET/release/rg" "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/rg"

installlicense "$_SRCDIR/UNLICENSE"

builddeb
