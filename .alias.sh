# custom alias
alias v="vim"
alias e="emacsclient -t"
alias ec="emacsclient -c"
alias haikunate="python3 -c 'import haikunator; print(haikunator.Haikunator().haikunate(token_length=0))'"
alias mpvd="mpv --screen=0 --fs-screen=1"
alias wgetu="wget -U 'Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'"
alias zathura="zathura --fork"

exifdiff() {
    [ "$#" -eq 2 ] || {
        echo "usage: $0 OLD NEW" >&2 && return 2
    }
    diff <(exiftool "$1") <(exiftool "$2")
}

# get user entry for process
whop(){
    ps --no-headers -p "$1"
    getent passwd "$(ps --no-headers -o uid -p "$1")"
}

# start VirtualBox VM in the background
startvm(){
    [[ "$#" -eq 1 ]] || return 1
    VirtualBox --startvm "$1" &
}
