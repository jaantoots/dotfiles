# load grml zsh config file if necessary
[[ -r $HOME/.zshrc.grml ]] && source $HOME/.zshrc.grml

# If not running interactively, stop here
[[ $- != *i* ]] && return

if [[ "$(uname)" = "Darwin" ]]; then
    alias ls='ls -FG'
    alias l='ls -laFG'
else
    alias lock='i3lock -fe -r 16 -s 4'
fi

alias e='emacsclient -t'
alias ec='emacsclient -c'

# Start VirtualBox VM in the background
startvm(){
    [[ "$#" -eq 1 ]] || return 1
    VirtualBox --startvm "$1" &
}

hash brew >/dev/null 2>&1 && {
    fpath=("$(brew --prefix)/share/zsh-completions" $fpath)
    if [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
    fi
}
true

if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
    . "${HOME}/.iterm2_shell_integration.zsh"
fi
