#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/ncal.c https://raw.githubusercontent.com/apple-oss-distributions/misc_cmds/misc_cmds-37/ncal/ncal.c
curl -L -# -o src/calendar.c https://raw.githubusercontent.com/apple-oss-distributions/misc_cmds/misc_cmds-37/ncal/calendar.c
curl -L -# -o src/calendar.h https://raw.githubusercontent.com/apple-oss-distributions/misc_cmds/misc_cmds-37/ncal/calendar.h
curl -L -# -o src/easter.c https://github.com/apple-oss-distributions/misc_cmds/raw/misc_cmds-37/ncal/easter.c
