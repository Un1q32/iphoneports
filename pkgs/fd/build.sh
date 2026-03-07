#!/bin/sh
. ../../files/lib.sh

if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_OSVER" -lt 1050 ]; }; then
    printf 'Rust requires at least Mac OS X 10.5 or iPhone OS 2.0\n'
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
# libdispatch
if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 40000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_OSVER" -lt 1060 ]; }; then
    sed -i 's|ctrlc = "3.5"|ctrlc = "3.4.7"|' Cargo.toml
    cargo update ctrlc --precise 3.4.7
fi
SDKROOT="$_SDK" cargo build --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp "target/$_RUSTTARGET/release/fd" "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/fd"

installlicense "$_SRCDIR/LICENSE-MIT"

builddeb
