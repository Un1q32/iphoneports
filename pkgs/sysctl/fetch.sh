#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/sysctl.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-541/sysctl.tproj/sysctl.c
