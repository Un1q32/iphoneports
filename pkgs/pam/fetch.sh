#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/apple-oss-distributions/pam/archive/refs/tags/pam-32.1.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv pam-pam-* "$_SRCDIR"
cd src || exit 1
printf "Downloading modules source...\n"
curl -L -# -o src.tar.gz https://github.com/apple-oss-distributions/pam_modules/archive/refs/tags/pam_modules-36.2.tar.gz
printf "Unpacking modules source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv pam_modules-pam_modules-* modules
