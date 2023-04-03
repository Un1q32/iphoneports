#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -H "X-Machine: iPod4,1" -H "X-Unique-ID: 0000000000000000000000000000000000000000" -H "X-Firmware: 6.1" -H "User-Agent: Telesphoreo APT-HTTP/1.0.999" -L -# -o source.deb https://repo.bingner.com/perl_5.26.1-6_iphoneos-arm.deb
printf "Unpacking source...\n"
dpkg-deb -x source.deb package
rm source.deb
