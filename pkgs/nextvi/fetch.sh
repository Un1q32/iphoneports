#!/bin/sh
commit=2da6476e28bdf8c806633f08226ad698489ca490
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/OldWorldOrdr/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
