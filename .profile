# User private bin if exists
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

export ALTERNATE_EDITOR=''
export EDITOR='emacsclient'

if [ -f "$HOME/.profile" ]; then
    . ~/.profile.local
fi
