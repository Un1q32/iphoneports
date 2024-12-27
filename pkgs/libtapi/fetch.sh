#!/bin/sh
commit=aa37c11ad1a817248c9d1578ac99e133875b4eb5
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/tpoechtrager/apple-libtapi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "apple-libtapi-${commit}" src
