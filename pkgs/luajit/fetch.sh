#!/bin/sh -e
commit=871db2c84ecefd70a850e03a6c340214a81739f0
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/LuaJIT/LuaJIT/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "LuaJIT-${commit}" src
