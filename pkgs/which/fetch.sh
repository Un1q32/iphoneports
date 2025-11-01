#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/which.c https://raw.githubusercontent.com/apple-oss-distributions/shell_cmds/shell_cmds-278/which/which.c
