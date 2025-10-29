#!/bin/sh
rm -rf pkg src
ver='4dd44a6f43d46af277249c58cf358d635239c41a'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "58bb48611140aaf528fc736e2c113dcaf1473be0224bfbcf370a0379b23de1be" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv cctools-port-* src
