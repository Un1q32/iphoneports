#!/bin/sh
commit=78a5ea269c1e1b5d18c0acc9e138476385ab1c3a
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/Un1q32/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
