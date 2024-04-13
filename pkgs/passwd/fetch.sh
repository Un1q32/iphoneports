#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -s -o src/passwd.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-433/passwd.tproj/passwd.c &
curl -L -s -o src/stringops.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-433/passwd.tproj/stringops.c &
curl -L -s -o src/file_passwd.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-433/passwd.tproj/file_passwd.c &
curl -L -s -o src/stringops.h https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-433/passwd.tproj/stringops.h
wait
