#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -L -s -o "$_SRCDIR/login.c" https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-336/login.tproj/login.c &
curl -L -s -o "$_SRCDIR/pathnames.h" https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-336/login.tproj/pathnames.h
wait
