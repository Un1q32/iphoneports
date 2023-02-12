#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://github.com/kkos/oniguruma/releases/download/v6.9.8/onig-6.9.8.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv onig-6.9.8 source
