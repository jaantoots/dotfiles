# Check if grml-zsh-config is installed locally

[[ -f $HOME/.zshrc.global ]] && source $HOME/.zshrc.global

# History
HISTSIZE=1048576
SAVEHIST=1048576
unsetopt histignorealldups
setopt histignoredups

# if not running interactively, stop here
[[ $- != *i* ]] && return

prefix=/usr/share/zsh/plugins
[[ -d "$prefix" ]] || prefix=$HOME/.local/share

source $prefix/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $prefix/zsh-history-substring-search/zsh-history-substring-search.zsh
source $prefix/zsh-autosuggestions/zsh-autosuggestions.zsh

unset prefix

ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# base16
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] &&
    eval "$($BASE16_SHELL/profile_helper.sh)"

# kitty
[[ $TERM = xterm-kitty ]] && source <(kitty +complete setup zsh)

# aliases
[[ -r $HOME/.aliases ]] && source $HOME/.aliases
