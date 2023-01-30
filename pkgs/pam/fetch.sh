#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.deb http://apt.saurik.com/cydia/debs/pam_32.1-4_iphoneos-arm.deb
printf "Unpacking source...\n"
dpkg-deb -x source.deb package
rm source.deb
