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
SDKROOT="$_SDK" cargo build --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp "target/$_RUSTTARGET/release/hyperfine" "$_DESTDIR/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/hyperfine

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE-* "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
