#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.deb http://apt.saurik.com/cydia/debs/pam_32.1-4_iphoneos-arm.deb
printf "Unpacking source...\n"
dpkg-deb -R src.deb pkg
rm src.deb
