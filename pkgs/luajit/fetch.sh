#!/bin/sh
rm -rf pkg src
ver='25a61a182166fec06f1a1a025eb8fabbb6cf483e'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/luajit-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luajit-$ver.tar.gz" | awk '{print $1}')" != "3fca2bb5068d7150d324a34eaac555757b8ce94f15565e0a0552373f7534081e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luajit-$ver.tar.gz" "https://github.com/LuaJIT/LuaJIT/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/luajit-$ver.tar.gz"
mv LuaJIT-* src
