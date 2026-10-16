#!/bin/sh
# Provision a Fedora toolbox; safe to re-run after adding packages:
#   toolbox create && toolbox run ~/dotfiles/fedora/toolbox.sh
set -eu

# Package list in the spirit of the Brewfile; comments are stripped
packages=$(sed 's/#.*//' <<'EOF'
# Core
stow
make

# Shell
zsh
zsh-syntax-highlighting
zsh-autosuggestions

# Search & navigation
fzf
fd-find
ripgrep
direnv

# Modern CLI
bat
eza
jq
git-delta

# Editors & multiplexer
neovim
vim-enhanced
tmux
lazygit             # dejan/lazygit COPR

# LazyVim (treesitter, mason, clipboard)
gcc
nodejs
npm
tree-sitter-cli
unzip
wl-clipboard

# Development
gh
postgresql          # psql
uv

# Utilities
pv
wget
htop
lm_sensors
sqlite
unar
EOF
)

sudo dnf copr enable -y dejan/lazygit
sudo dnf install -y $packages

# pure prompt isn't packaged in Fedora; the clone lands in the shared home
[ -d ~/.local/share/zsh/pure ] ||
  git clone https://github.com/sindresorhus/pure.git ~/.local/share/zsh/pure
