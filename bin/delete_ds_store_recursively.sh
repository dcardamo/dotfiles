#!/bin/sh

cd ~ || exit
find . -name ".DS_Store" -type f -print  -delete
