#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir src
curl -L -s -o src/login.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-336/login.tproj/login.c &
curl -L -s -o src/pathnames.h https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-336/login.tproj/pathnames.h
wait
