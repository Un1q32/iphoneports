#!/bin/sh
(
cd package || exit 1
arch="${_TARGET%%-*}"
if [ "$arch" = "arm" ]; then
    arch="armv6"
fi
"$_TARGET-lipo" -extract "$arch" usr/bin/perl -output usr/bin/perl
case "$arch" in
    *64*) mv usr/lib/perl5/5.26.1/armv7s-iphoneos . ;;
    *) mv usr/lib/perl5/5.26.1/"$arch"-iphoneos . ;;
esac
rm -rf usr/lib/perl5/5.26.1/*-iphoneos usr/share
mv ./*-iphoneos usr/lib/perl5/5.26.1
"$_TARGET-strip" usr/bin/perl -no_code_signature_warning
ldid -S"$_BSROOT/entitlements.xml" usr/bin/perl
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package perl-5.26.1.deb
