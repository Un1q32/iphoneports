#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git src
cd src || exit 1
git -c advice.detachedHead=false checkout f73e649a954b599fc184726c376476e7a5c439ca
