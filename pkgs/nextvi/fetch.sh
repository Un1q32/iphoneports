#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/kyx0r/nextvi/archive/6cc14fa7e4c70923fce5ea862f31d52d25304be7.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv nextvi-6cc14fa7e4c70923fce5ea862f31d52d25304be7 src
