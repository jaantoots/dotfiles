ANTIGEN="/usr/share/zsh/share/antigen.zsh"

if [[ ! -f $ANTIGEN ]] && [[ -f "$HOME/.linuxbrew/share/antigen/antigen.zsh" ]]; then
    ANTIGEN=$HOME/.linuxbrew/share/antigen/antigen.zsh
fi

if [[ ! -f $ANTIGEN ]] && [[ -f "/usr/local/share/antigen/antigen.zsh" ]]; then
    ANTIGEN=/usr/local/share/antigen/antigen.zsh
fi

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

# Load the theme
antigen theme dieter

# Tell antigen that you're done
antigen apply

# Fix some things
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=accept-line-or-clear-warning

# if not running interactively, stop here
[[ $- != *i* ]] && return

# include iterm2 integration if it exists
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
    . "${HOME}/.iterm2_shell_integration.zsh"
fi

# base16
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] \
    && eval "$($BASE16_SHELL/profile_helper.sh)"

#
[[ -r $HOME/.alias.sh ]] && source $HOME/.alias.sh
