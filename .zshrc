ANTIGEN="$HOME/.config/antigen/antigen.zsh"

source $ANTIGEN

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Load plugins
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle gitignore
antigen bundle pip

# Load the theme
antigen theme dieter

# Tell antigen that you're done
antigen apply

# Fix some things
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=accept-line-or-clear-warning

# if not running interactively, stop here
[[ $- != *i* ]] && return

# base16
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] \
    && eval "$($BASE16_SHELL/profile_helper.sh)"

#
[[ -r $HOME/.alias.sh ]] && source $HOME/.alias.sh
