#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.deb https://humantrafficing.net/ca-certificates-20221209-0219.deb
printf "Unpacking source...\n"
dpkg-deb -x source.deb package
rm source.deb
