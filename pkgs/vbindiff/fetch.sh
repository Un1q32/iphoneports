#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
{ curl -L -s https://github.com/madsen/free-getopt/archive/44a5db045fc7fda9ec757ea37b7cdbdf53c452b1.tar.gz | tar xz; } &
curl -L -s -o src.tar.gz https://github.com/madsen/vbindiff/archive/e478092dfbc0777b899783ba90d104d0a3bdd32f.tar.gz
tar xf src.tar.gz
mv vbindiff-e478092dfbc0777b899783ba90d104d0a3bdd32f src
rm -r src/GetOpt src.tar.gz
wait
mv free-getopt-44a5db045fc7fda9ec757ea37b7cdbdf53c452b1 src/GetOpt
