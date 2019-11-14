alias v="vim"
alias e="emacsclient -t"
alias ec="emacsclient -c"
alias lsb="lsblk -oNAME,TYPE,MAJ:MIN,RM,SUBSYSTEMS,MODEL,SIZE,RO,FSTYPE,FSSIZE,FSUSE%,FSUSED,FSAVAIL,MOUNTPOINT"
alias dg="dmenu-open"
alias mpvd="mpv --screen=0 --fs-screen=1"
alias ssh="TERM=${SSH_TERM:-$TERM} ssh"
alias wgetu="wget -U 'Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'"
alias zathura="zathura --fork"

20to5f() {
    [ "$#" -ge 1 ] || {
        echo "usage: $0 FILE..." >&2 && return 1
    }
    for f in "$@"; do
        mv -iv "$f" "${f// /_}"
    done
}

cpv() {
    [ "$#" -eq 2 ] || {
        echo "usage: $0 SRC DEST" >&2 && return 1
    }
    tar -c "$1" | pv -pterb -s "$(du -bs "$1" | cut -f1)" | tar -C "$2" -xp
}

docker-tags() {
    for item; do
        token="$(curl -sG \
            --data-urlencode service=registry.docker.io \
            --data-urlencode scope=repository:$item:pull \
            https://auth.docker.io/token |
            jq -r '.token')"
        curl -sG \
            -H "Accept: application/json" \
            -H "Authorization: Bearer $token" \
            https://registry-1.docker.io/v2/$item/tags/list |
            jq
    done
}

exifdiff() {
    [ "$#" -eq 2 ] || {
        echo "usage: $0 OLD NEW" >&2 && return 2
    }
    diff <(exiftool "$1") <(exiftool "$2")
}

# get user entry for process
whop() {
    ps --no-headers -p "$1"
    getent passwd "$(ps --no-headers -o uid -p "$1")"
}

# start VirtualBox VM in the background
startvm() {
    [[ "$#" -eq 1 ]] || return 1
    VirtualBox --startvm "$1" &
}

# open recent file with zathura
zh() {
    sed -nE '/^\[.+\]$/h;/^time=[0-9]+$/{x;G;s/^\[(.+)\]\ntime=([0-9]+)$/\2 \1/p}' \
        .local/share/zathura/history |
        sort -nr | cut -d ' ' -f 2- | dmenu -p zathura | xargs -r zathura --fork
}
