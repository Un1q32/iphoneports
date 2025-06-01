#!/bin/sh -e
commit=f9140a622a0c44a99efb391cc1c2358bc8098ab7
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/LuaJIT/LuaJIT/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "LuaJIT-${commit}" src
