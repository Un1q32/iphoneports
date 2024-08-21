#!/bin/sh
commit=f048aedb5e6360d1617e773b4ea793cb0b6e3fdd
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/ingelabs/classpath/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "classpath-${commit}" src
