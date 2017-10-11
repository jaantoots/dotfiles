# custom alias
alias lock='i3lock -fe -r 16 -s 4'
alias e='emacsclient -t'
alias ec='emacsclient -c'

# start VirtualBox VM in the background
startvm(){
    [[ "$#" -eq 1 ]] || return 1
    VirtualBox --startvm "$1" &
}
