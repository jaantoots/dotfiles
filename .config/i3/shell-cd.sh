#!/bin/bash

cd="$HOME"

while read pid cmd; do
    grep -q "$(cut -d " " -f 1 <<<"$cmd")" /etc/shells && break
done < <(
    xdpyinfo | grep -m 1 -E '^focus' | cut -d " " -f 4 | tr -d ',' |
        xargs -r xprop -id | grep -m 1 PID | cut -d " " -f 3 |
        xargs -r ps -o pid=,cmd= --ppid
)

if [ -n "$pid" ]; then
    cd="$(readlink "/proc/$pid/cwd")"
fi

echo "$cd"
