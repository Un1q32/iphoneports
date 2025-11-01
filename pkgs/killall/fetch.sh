#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -L -# -o "$_SRCDIR/killall.c" https://raw.githubusercontent.com/apple-oss-distributions/shell_cmds/shell_cmds-302.0.1/killall/killall.c
