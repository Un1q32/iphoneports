#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -L -# -o "$_SRCDIR/whois.c" https://raw.githubusercontent.com/apple-oss-distributions/adv_cmds/adv_cmds-199.0.1/whois/whois.c
