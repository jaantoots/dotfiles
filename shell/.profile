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

# rust
if [ -d "$HOME/.cargo/bin" ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# set PATH so it includes user's private bin directories
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# set ssh agent socket if not set by agent forwarding
if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi

export ALTERNATE_EDITOR=vi
export EDITOR=vim
export SUDO_EDITOR=rvim
export SYSTEMD_EDITOR=rvim
export BROWSER=lynx
export LESS=FRj4
export SYSTEMD_LESS=${LESS}SMK

# use the local file for private variables (e.g. API keys)
if [ -f "$HOME/.profile.local" ]; then
    . "$HOME/.profile.local"
fi
