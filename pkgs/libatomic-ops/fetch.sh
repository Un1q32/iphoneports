#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://github.com/ivmai/libatomic_ops/releases/download/v7.6.14/libatomic_ops-7.6.14.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv libatomic_ops-7.6.14 source
