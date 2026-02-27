#!/bin/sh

set -e

if [ -z "$_PKGNAME" ]; then
    printf 'Do not run this script directly, use the main build.sh\n'
    exit 1
fi

strip_and_sign() {
    for file in "$@"; do
        magic=$(od -An -tx1 -j12 -N4 "$file" | tr -d ' \n')
        if [ "$magic" = "02000000" ]; then
            "$_TARGET-strip" -no_code_signature_warning "$file" # executable file
        else
            "$_TARGET-strip" -no_code_signature_warning -x "$file" # other, probably dylib
        fi
    done
    if { [ "$_SUBSYSTEM" != "macos" ] && [ "$_OSVER" -ge 20000 ]; } ||
        [ "$_CPU" = "arm64" ] || [ "$_CPU" = "arm64e" ] ||
        [ "$_ALWAYSSIGN" = 1 ]; then
        ldid -S"$_ENTITLEMENTS" "$@"
    fi
}

builddeb() {
    cp -r DEBIAN "$_DESTDIR"
    sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > "$_DESTDIR/DEBIAN/control"
    dpkg-deb -b --root-owner-group -Zgzip "$_DESTDIR" "$_PKGNAME-$_TARGET.deb"
}

installlicense() {
    mkdir -p "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"
    cp "$@" "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"
}

installsuid() {
    mkdir -p "$_DESTDIR/usr/local/libexec/iphoneports"
    for bin in "$@"; do
        mv "$bin" "$_DESTDIR/usr/local/libexec/iphoneports"
        ln -s "../../../../usr/local/libexec/iphoneports/${bin##*/}" "$bin"
    done
}

make() {
    command "$_MAKE" -j"$_JOBS" "$@"
}

ninja() {
    command ninja -j"$_JOBS" "$@"
}
