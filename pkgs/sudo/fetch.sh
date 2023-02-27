#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://github.com/sudo-project/sudo/releases/download/TAG/sudo-1.9.13p2.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv sudo-1.9.13p2 source
