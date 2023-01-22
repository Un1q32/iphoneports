#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://github.com/sudo-project/sudo/archive/refs/tags/SUDO_1_9_12p2.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv sudo-SUDO_1_9_12p2 source
