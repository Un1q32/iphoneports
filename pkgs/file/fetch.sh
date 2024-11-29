#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz ftp://ftp.astron.com/pub/file/file-5.46.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv file-5.46 src
