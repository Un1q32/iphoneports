#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/Un1q32/icon-fix.git src --depth 1
