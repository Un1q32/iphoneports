#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -L -# -o "$_SRCDIR/sysctl.c" https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-541/sysctl.tproj/sysctl.c
