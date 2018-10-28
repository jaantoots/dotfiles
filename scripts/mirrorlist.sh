#!/bin/bash

sed -nE '/^## Arch Linux repository mirrorlist/,$s/^#(Server = .*)/\1/p' \
    /etc/pacman.d/mirrorlist > mirrorlist
rankmirrors -v mirrorlist | tee mirrorlist.rank

join \
    <(curl -qs https://www.archlinux.org/mirrors/status/json/ |
        jq -r '.urls | [.[] | select((.score | type) == "number")] |
            .[] | "\(.url)$repo/os/$arch \(.score)"' | sort)
    <(awk '/^# .* \.\.\. [0-9.]+/ {print $2, $4;}' mirrorlist.rank | sort) |
        sort -nk 2 | awk '{print $0, NR;}' |
        sort -nk 3 | awk '{print $0, NR, $4 + NR;}' |
        sort -nk 6 | column -t | awk '{print "#" $0; print "#Server = " $1;}'
