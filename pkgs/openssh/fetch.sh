#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -# -o src.tar.gz https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.9p2.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv openssh-* src
