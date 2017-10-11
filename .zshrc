# load grml zsh config file if necessary
[[ -r $HOME/.zshrc.grml ]] && source $HOME/.zshrc.grml

# if not running interactively, stop here
[[ $- != *i* ]] && return

# brew zsh
hash brew >/dev/null 2>&1 && {
    fpath=("$(brew --prefix)/share/zsh-completions" $fpath)
    if [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
    fi
}
true
# include iterm2 integration if it exists
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
    . "${HOME}/.iterm2_shell_integration.zsh"
fi

#
[[ -r $HOME/.alias.sh ]] && source $HOME/.alias.sh
