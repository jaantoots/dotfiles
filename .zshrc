# History
HISTSIZE=1048576
SAVEHIST=1048576

# if not running interactively, stop here
[[ $- != *i* ]] && return

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

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
[[ -r $HOME/.alias.sh ]] && source $HOME/.alias.sh
