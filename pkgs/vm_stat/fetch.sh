#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -L -# -o "$_SRCDIR/vm_stat.c" https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-431/vm_stat.tproj/vm_stat.c
