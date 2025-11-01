#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir src
curl -L -s -o src/ifconfig.c https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-325/ifconfig.tproj/ifconfig.c &
curl -L -s -o src/ifmedia.c https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-325/ifconfig.tproj/ifmedia.c &
curl -L -s -o src/ifconfig.h https://raw.githubusercontent.com/apple-oss-distributions/network_cmds/network_cmds-325/ifconfig.tproj/ifconfig.h &
wait
