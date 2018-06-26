#!/bin/bash

cd="$HOME"

window="$(xdpyinfo | grep -m 1 -E '^focus' | cut -d " " -f 4 | tr -d ',')"
if [ -n "$window" ]; then
    wpid="$(xprop -id "$window" | grep -m 1 PID | cut -d " " -f 3)"
fi

if [ -n "$wpid" ]; then
    while read pid; do
        grep -q "$(ps -o comm= -p "$pid")" /etc/shells && break
    done <<<"$(ps --ppid "$wpid" -o pid=)"
fi

if [ -n "$pid" ]; then
    cd="$(readlink "/proc/$pid/cwd")"
fi

echo "$cd"
