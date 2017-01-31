# Set environment variables first
if [[ -f $HOME/.profile ]]; then
    . ~/.profile
fi

# If not running interactively, stop here
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

if [[ "$(uname)" = "Darwin" ]]; then
    alias ls='ls -FG'
    alias l='ls -laFG'
else
    alias ls='ls -F --color=auto'
    alias l='ls -laF --color=auto'
    alias lock='i3lock -fe -r 16 -s 4'
fi

alias e='emacsclient -t'
alias ec='emacsclient -c'

# Start VirtualBox VM in the background
startvm(){
    [[ "$#" -eq 1 ]] || return 1
    VirtualBox --startvm "$1" &
}

# Homebrew
hash brew >/dev/null 2>&1 && {
    if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        . "$(brew --prefix)/etc/bash_completion"
    fi
}
true
