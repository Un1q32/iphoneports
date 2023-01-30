#!/bin/sh
(
cd package || exit 1
ln -s pam usr/include/security
)

dpkg-deb -b --root-owner-group -Zgzip package pam-32.1.deb
