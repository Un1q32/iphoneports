#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.bz2 https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.bz2
printf "Unpacking source...\n"
tar -xf source.tar.bz2
rm source.tar.bz2
mv pcre2-10.42 source
