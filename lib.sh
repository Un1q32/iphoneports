#!/bin/sh

if [ -z "$_PKGNAME" ]; then
    printf 'Do not run this script directly, use the main build.sh\n'
    exit 1
fi

strip_and_sign() {
    "$_TARGET-strip" -no_code_signature_warning "$@" 2>/dev/null || true
    if { [ "$_SUBSYSTEM" != "macos" ] && [ "$_TRUEOSVER" -ge 20000 ]; } ||
        [ "$_CPU" = "arm64" ] || [ "$_CPU" = "arm64e" ] ||
        [ "$_ALWAYSSIGN" = 1 ]; then
        ldid -S"$_ENTITLEMENTS" "$@"
    fi
}
