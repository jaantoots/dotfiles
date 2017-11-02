# custom alias
alias e='emacsclient -t'
alias ec='emacsclient -c'
alias emacs='TERM=${TERM/256color/16color} emacs'
alias emacsclient='TERM=${TERM/256color/16color} emacsclient'
alias haikunate='python3 -c "import haikunator; print(haikunator.Haikunator().haikunate(token_length=0))"'
alias lock='i3lock -fe -r 16 -s 4'
alias mpvd='mpv --screen=0 --fs-screen=1'
alias wgetu="wget -U 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/61.0.3163.100 Chrome/61.0.3163.100 Safari/537.36'"

# start VirtualBox VM in the background
startvm(){
    [[ "$#" -eq 1 ]] || return 1
    VirtualBox --startvm "$1" &
}

# add transfer.sh function
source "$HOME/config/transfer.sh/transfer.sh"
