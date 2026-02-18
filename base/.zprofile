export EDITOR=nvim

eval "$(/opt/homebrew/bin/brew shellenv)"
fpath[1,0]="$HOMEBREW_PREFIX/share/zsh-completions";

export PATH="$HOME/.docker/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
