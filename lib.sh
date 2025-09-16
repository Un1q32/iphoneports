#!/bin/sh

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
    if { [ "$_SUBSYSTEM" != "macos" ] && [ "$_TRUEOSVER" -ge 20000 ]; } ||
        [ "$_CPU" = "arm64" ] || [ "$_CPU" = "arm64e" ] ||
        [ "$_ALWAYSSIGN" = 1 ]; then
        ldid -S"$_ENTITLEMENTS" "$@"
    fi
}
