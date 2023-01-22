#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://github.com/cowsay-org/cowsay/archive/refs/tags/v3.7.0.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv cowsay-3.7.0 source
