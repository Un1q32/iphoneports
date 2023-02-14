#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv LuaJIT-2.1.0-beta3 source
