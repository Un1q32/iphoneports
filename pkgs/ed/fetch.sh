#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/main.c https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-154/ed/main.c
curl -L -# -o src/ed.h https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-138.100.3/ed/ed.h
curl -L -# -o src/io.c https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-138.100.3/ed/io.c
curl -L -# -o src/buf.c https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-138.100.3/ed/buf.c
curl -L -# -o src/re.c https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-138.100.3/ed/re.c
curl -L -# -o src/glbl.c https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-138.100.3/ed/glbl.c
curl -L -# -o src/undo.c https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-138.100.3/ed/undo.c
curl -L -# -o src/sub.c https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-138.100.3/ed/sub.c
