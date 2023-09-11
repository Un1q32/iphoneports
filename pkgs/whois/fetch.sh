#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/whois.c https://raw.githubusercontent.com/apple-oss-distributions/adv_cmds/adv_cmds-199.0.1/whois/whois.c
