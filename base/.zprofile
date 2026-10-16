export EDITOR=nvim

# Homebrew (macOS)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  fpath[1,0]="$HOMEBREW_PREFIX/share/zsh-completions"
  path=("$HOMEBREW_PREFIX/opt/libpq/bin" $path)
fi

# User bin dirs, each only if it exists on this machine
typeset -U path
path=(~/.cargo/bin(N/) ~/.local/bin(N/) ~/.docker/bin(N/) $path)
