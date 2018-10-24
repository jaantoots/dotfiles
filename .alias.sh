alias v="vim"
alias e="emacsclient -t"
alias ec="emacsclient -c"
alias mpvd="mpv --screen=0 --fs-screen=1"
alias ssh="TERM=${SSH_TERM:-$TERM} ssh"
alias wgetu="wget -U 'Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'"
alias zathura="zathura --fork"

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
    cat .local/share/zathura/history |
        sed -nE '/^\[.+\]$/h;/^time=[0-9]+$/{x;G;s/^\[(.+)\]\ntime=([0-9]+)$/\2 \1/p}' |
        sort -nr | cut -d ' ' -f 2- | dmenu | xargs -r zathura --fork
}
