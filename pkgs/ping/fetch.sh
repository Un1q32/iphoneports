#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir src
curl -L -s -o src/ping.c https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-307/ping.tproj/ping.c &
for src in ping6.c md5.c md5.h; do
    curl -L -s -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-307/ping6.tproj/$src" &
done
wait
