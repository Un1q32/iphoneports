#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/ping.c https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-325/ping.tproj/ping.c
