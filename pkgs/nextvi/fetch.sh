#!/bin/sh
commit=d14229c61cedd9a9c83ee8b00f790b454241de48
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/kyx0r/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
