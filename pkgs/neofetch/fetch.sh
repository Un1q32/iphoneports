#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/hykilpikonna/hyfetch/53bbd3fdf8ccbc457e2e2eaa1782582de778214d/neofetch
chmod 755 src/neofetch
