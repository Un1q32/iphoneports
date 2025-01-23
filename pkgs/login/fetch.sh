#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -s -o src/login.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-433/login.tproj/login.c &
curl -L -s -o src/pathnames.h https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-433/login.tproj/pathnames.h
wait
