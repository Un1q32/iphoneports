#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/cert.pem https://curl.se/ca/cacert-2024-12-31.pem
