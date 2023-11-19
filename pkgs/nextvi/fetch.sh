#!/bin/sh
commit=a10d8a16fce1f4bcbb61b75d0db50a382d9a89ed
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/kyx0r/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
