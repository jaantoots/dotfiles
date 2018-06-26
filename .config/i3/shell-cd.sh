#!/bin/bash

cd="$HOME"

while read pid; do
    grep -q "$(ps -o comm= -p "$pid")" /etc/shells && break
done < <(
    xdpyinfo | grep -m 1 -E '^focus' | cut -d " " -f 4 | tr -d ',' | \
        xargs -r xprop -id | grep -m 1 PID | cut -d " " -f 3 | \
        xargs -r ps -o pid= --ppid
)

if [ -n "$pid" ]; then
    cd="$(readlink "/proc/$pid/cwd")"
fi

echo "$cd"
