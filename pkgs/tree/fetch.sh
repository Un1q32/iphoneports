#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://oldmanprogrammer.net/tar/tree/tree-2.1.3.tgz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv tree-2.1.3 src
