#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://mama.indstate.edu/users/ice/tree/src/tree-2.1.1.tgz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv tree-2.1.1 source
