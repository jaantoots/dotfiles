# custom alias
if [[ "$(uname)" = "Darwin" ]]; then
    alias ls='ls -FG'
    alias l='ls -laFG'
else
    alias lock='i3lock -fe -r 16 -s 4'
fi

alias e='emacsclient -t'
alias ec='emacsclient -c'

# start VirtualBox VM in the background
startvm(){
    [[ "$#" -eq 1 ]] || return 1
    VirtualBox --startvm "$1" &
}
