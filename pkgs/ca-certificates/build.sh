#!/bin/sh
"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ca-certificates-20221209-0219.deb
