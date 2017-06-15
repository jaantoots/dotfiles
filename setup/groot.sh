#!/bin/bash

usage() { echo "usage: $0 [-d]" 1>&2; exit 1; }

decrypt=false

while getopts ":d" o; do
    case "${o}" in
        d)
            decrypt=true
            ;;
        *)
            usage
    esac
done

if [ $decrypt = true ]; then
    tr -Cd '.,!?' | tr '.,!?' '0123' | ./groot.out -d | xxd -r -p | gzip -d
else
    gzip | xxd -p | tr -d '\n' | ./groot.out |\
        tr '0123' '.,!?' | sed 's/\(.\)/I am Groot\1 /g'
fi
