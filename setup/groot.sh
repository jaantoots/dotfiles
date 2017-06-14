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
        sed 's/0/I am Groot. /g' | sed 's/1/I am Groot, /g' |\
        sed 's/2/I am Groot! /g' | sed 's/3/I am Groot? /g'
fi
