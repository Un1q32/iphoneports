#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/ncal.c https://opensource.apple.com/source/misc_cmds/misc_cmds-34/ncal/ncal.c
curl -L -# -o src/calendar.c https://opensource.apple.com/source/misc_cmds/misc_cmds-34/ncal/calendar.c
curl -L -# -o src/calendar.h https://opensource.apple.com/source/misc_cmds/misc_cmds-34/ncal/calendar.h
curl -L -# -o src/easter.c https://opensource.apple.com/source/misc_cmds/misc_cmds-34/ncal/easter.c
