source $HOME/config/antigen/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Load plugins
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle gitignore

# Load the theme
antigen theme dieter
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=accept-line-or-clear-warning

# Tell antigen that you're done
antigen apply

# if not running interactively, stop here
[[ $- != *i* ]] && return

# include iterm2 integration if it exists
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
    . "${HOME}/.iterm2_shell_integration.zsh"
fi

#
[[ -r $HOME/.alias.sh ]] && source $HOME/.alias.sh
