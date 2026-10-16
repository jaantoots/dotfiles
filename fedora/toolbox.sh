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
vim-default-editor
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
# --allowerasing: vim-default-editor replaces nano-default-editor
sudo dnf install -y --allowerasing $packages

# Not packaged in Fedora; these land in the shared home, so the host gets them too
uv tool install ast-grep-cli
[ -d ~/.local/share/zsh/pure ] ||
  git clone https://github.com/sindresorhus/pure.git ~/.local/share/zsh/pure
