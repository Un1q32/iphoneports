#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://git.tukaani.org/xz.git -b v5.4.6 src --depth 1
