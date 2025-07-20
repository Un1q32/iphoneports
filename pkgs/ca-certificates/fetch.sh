#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/cert.pem https://curl.se/ca/cacert-2025-07-15.pem
