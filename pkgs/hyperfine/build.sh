#!/bin/sh
. ../../files/lib.sh

if ! supportsrust; then
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
SDKROOT="$_SDK" cargo build --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp "target/$_RUSTTARGET/release/hyperfine" "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/hyperfine"

installlicense "$_SRCDIR"/LICENSE-*

builddeb
