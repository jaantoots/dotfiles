# History
HISTSIZE=1048576
SAVEHIST=1048576
unsetopt histignorealldups
setopt histignoredups
setopt histreduceblanks
unsetopt sharehistory
setopt incappendhistorytime

# if not running interactively, stop here
[[ $- != *i* ]] && return

# Load plugins
load_plugin() {
    prefix=/usr/share/zsh/plugins
    # Try the following if using Debian
    [[ -d "$prefix" ]] || prefix=/usr/share
    [[ -f "$prefix/$1/$1.zsh" ]] && source "$prefix/$1/$1.zsh"
    unset prefix
}

load_plugin zsh-syntax-highlighting
load_plugin zsh-history-substring-search
load_plugin zsh-autosuggestions

unfunction load_plugin

ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# base16
BASE16_SHELL=$HOME/.config/base16-shell/
[[ -n "$PS1" ]] && [[ -s "$BASE16_SHELL/profile_helper.sh" ]] &&
    eval "$("$BASE16_SHELL/profile_helper.sh")"

# fzf
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND="fd -H -E .git --type f | sort"

# aliases
[[ -r $HOME/.aliases ]] && source "$HOME/.aliases"

true
