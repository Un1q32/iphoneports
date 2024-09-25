#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/cert.pem https://curl.se/ca/cacert-2024-09-24.pem
