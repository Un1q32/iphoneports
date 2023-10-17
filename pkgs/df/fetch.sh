#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/df.c https://raw.githubusercontent.com/apple-oss-distributions/file_cmds/file_cmds-428/df/df.c
