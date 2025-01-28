#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -s -o src/ping.c https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-325/ping.tproj/ping.c &
for src in ping6.c md5.c md5.h; do
    curl -L -s -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-325/ping6.tproj/$src" &
done
wait
