# Shell options
setopt auto_cd extended_glob notify auto_pushd pushd_ignore_dups
setopt nobeep interactive_comments completeinword correct nohup

# History
HISTFILE=~/.zsh_history
HISTSIZE=1048576
SAVEHIST=1048576
setopt append_history extended_history hist_ignore_space
setopt hist_ignore_dups hist_reduce_blanks inc_append_history_time

# Emacs keybindings
bindkey -e
# Edit command line in $EDITOR (Esc-e)
autoload -Uz edit-command-line && zle -N edit-command-line
bindkey '\ee' edit-command-line
# Ctrl-z to fg
grml-zsh-fg() { BUFFER="fg"; zle accept-line }
zle -N grml-zsh-fg
bindkey '^z' grml-zsh-fg
# Ctrl-o s to prepend sudo
sudo-command-line() { [[ -z $BUFFER ]] && zle up-history; LBUFFER="sudo $LBUFFER" }
zle -N sudo-command-line
bindkey '^os' sudo-command-line
# Space expands history (!! !$)
bindkey ' ' magic-space
# Home/End/Delete
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line
[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char

# Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' verbose true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:manuals' separate-sections true
autoload -Uz compinit && compinit
zmodload zsh/complist
[[ -n "${terminfo[kcbt]}" ]] && bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete

# Helper
xsource() { for f in "$@"; do [[ -r "$f" ]] && source "$f"; done }
ZSH_PLUGIN_DIRS=("${HOMEBREW_PREFIX:-/usr}"/share /usr/share/zsh/plugins)

# Plugins
xsource ${^ZSH_PLUGIN_DIRS}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
xsource ${^ZSH_PLUGIN_DIRS}/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

# fzf
export FZF_DEFAULT_COMMAND="fd -H -E .git --type f | sort"
export FZF_CTRL_T_COMMAND="fd -H -E .git | sort"
command -v fzf &>/dev/null && source <(fzf --zsh)

# Tools
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# Prompt
autoload -U promptinit; promptinit
prompt pure

# Utilities from grml
mkcd() { mkdir -p "$@" && cd "${@[-1]}" }
alias ...='cd ../../'

# Aliases
xsource "$HOME/.aliases"
