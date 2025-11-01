#!/bin/sh
. ../../files/lib.sh

# hack to make bat not include the iphoneports git rev
mkdir -p "$_SRCDIR/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_SRCDIR/iphoneports-fakebin/git"
chmod +x "$_SRCDIR/iphoneports-fakebin/git"
export PATH="$_SRCDIR/iphoneports-fakebin:$PATH"

if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_OSVER" -lt 1050 ]; }; then
    printf 'Rust requires at least Mac OS X 10.5 or iPhone OS 2.0\n'
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
SDKROOT="$_SDK" \
    TARGET_CC="$_TARGET-cc" \
    TARGET_PKG_CONFIG=pkg-config \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK" \
    LIBGIT2_NO_VENDOR=1 \
    cargo build --target "$_RUSTTARGET" --release -j "$_JOBS" \
    --config 'patch.crates-io.cc.git="https://github.com/Un1q32/cc-rs.git"' \
    --config 'patch.crates-io.cc.branch="1.0.83"'
mkdir -p "$_DESTDIR/var/usr/bin"
cp "target/$_RUSTTARGET/release/bat" "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/bat"

installlicense "$_SRCDIR"/LICENSE-*

builddeb
