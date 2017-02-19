#!/bin/bash

usage() { echo "Usage: $0 [-f] [-n]" 1>&2; exit 1; }

dry_run=false
proceed=false

while getopts ":fn" o; do
    case "${o}" in
        f)
            proceed=true
            ;;
        n)
            dry_run=true
            ;;
        *)
            usage
    esac
done

if [ $dry_run = false ] && [ $proceed = false ]; then
    echo "fatal: neither -n nor -f given; refusing to proceed" 1>&2
    exit 1
fi

BLUE='\033[0;34m'
RED='\033[1;31m'
BOLD='\033[1m'
NC='\033[0m'

ohce() { echo -e "${BLUE}==>${NC} ${BOLD}$*${NC}"; }
odie () { echo -e "${RED}!!!${NC} $*"; }

if [ $dry_run = true ]; then
    odie "Dry-run is set"
    for dir in *; do
        ohce "$dir"
        git --git-dir="$dir" fetch --prune --dry-run
    done
elif [ $proceed = true ]; then
    for dir in *; do
        ohce "$dir"
        git --git-dir="$dir" fetch --prune 
    done
fi
