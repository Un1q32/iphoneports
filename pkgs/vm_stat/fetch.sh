#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/vm_stat.c https://raw.githubusercontent.com/apple-oss-distributions/system_cmds/system_cmds-498.0.10/vm_stat.tproj/vm_stat.c
