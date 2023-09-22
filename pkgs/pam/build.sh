#!/bin/sh
cp files/*.h pkg/usr/include/pam
ln -s pam pkg/usr/include/security
rm -rf pkg/DEBIAN pkg/etc
