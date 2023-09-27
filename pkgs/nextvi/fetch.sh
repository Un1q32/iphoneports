#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/kyx0r/nextvi.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 0a65131559fcbd7a8d6ed9d7c02e78bd37a938ac
