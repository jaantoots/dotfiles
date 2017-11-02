# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# linuxbrew
if [ -d "$HOME/.linuxbrew" ]; then
    PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    MANPATH="$(brew --prefix)/share/man:$MANPATH"
    INFOPATH="$(brew --prefix)/share/info:$INFOPATH"
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

export ALTERNATE_EDITOR=''
export EDITOR='emacsclient'

# use the local file for private variables (e.g. API keys)
if [ -f "$HOME/.profile.local" ]; then
    . "$HOME/.profile.local"
fi

# just run zsh
hash zsh >/dev/null 2>&1 && {
    export SHELL=$(which zsh)
    [ -z "$ZSH_VERSION" ] && exec $SHELL -l
} || true
