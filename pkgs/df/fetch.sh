#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/df.c https://raw.githubusercontent.com/apple-oss-distributions/file_cmds/file_cmds-403.100.6/df/df.c
curl -L -# -o src/vfslist.c https://raw.githubusercontent.com/apple-oss-distributions/file_cmds/file_cmds-403.100.6/df/vfslist.c
