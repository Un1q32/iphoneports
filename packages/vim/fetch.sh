#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
git clone --depth 1 https://github.com/vim/vim.git source