#!/bin/sh
(
cd package || exit 1
ln -s pam usr/include/security
)
