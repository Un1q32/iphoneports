#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://mama.indstate.edu/users/ice/tree/src/tree-2.1.1.tgz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv tree-2.1.1 src
