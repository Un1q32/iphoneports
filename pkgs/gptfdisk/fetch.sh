#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.10/gptfdisk-1.0.10.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv gptfdisk-1.0.10 src
