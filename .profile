# User private bin if exists
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

export ALTERNATE_EDITOR=''
export EDITOR='emacsclient'

# Use the local file for private variables (e.g. API keys)
if [ -f "$HOME/.profile.local" ]; then
    . ~/.profile.local
fi
