#!/bin/sh
. ../../files/lib.sh

mkdir -p "$_DESTDIR/var/usr/etc/profile.d"
cp files/sdkroot.sh "$_DESTDIR/var/usr/etc/profile.d"
cp -a "$_SDK" "$_DESTDIR/var/usr/sdk"

if ! [ -f "$_DESTDIR/var/usr/sdk/SDKSettings.json" ] && [ "$_CPU" = 'arm64' ]; then
    case $_SUBSYSTEM in
        (ios)     subsystem=iphoneos  ;;
        (tvos)    subsystem=appletvos ;;
        (macos)   subsystem=macosx    ;;
        (watchos) subsystem=watchos   ;;
    esac

    sed -e "s/@VERSION@/$_SUBSYSTEMVER/g" \
        -e "s/@SUBSYSTEM@/$subsystem/g" \
        files/SDKSettings.json > "$_DESTDIR/var/usr/sdk/SDKSettings.json"
fi

builddeb
