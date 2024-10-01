#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/sysctl.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-979.100.8/sysctl/sysctl.c
