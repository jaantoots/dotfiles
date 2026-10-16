# Dotfiles

My dotfiles, used on macOS and on Fedora Silverblue (with a toolbox for CLI
work). `base/` is the only [stow](https://www.gnu.org/software/stow/) package.

```
git clone git@github.com:jaantoots/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow base
```

Stow refuses to replace existing files: move them out of the way first, or
`stow --adopt base` and review what got pulled in with `git diff`.

## macOS

```
brew bundle
```

## Fedora Silverblue

The host and toolboxes share `$HOME`, so everything in `base/` runs in both
places. The host only has a minimal set of tools, so configs have to cope with
missing commands (guard with `command -v`).

`toolbox enter` starts a login shell like macOS terminals do, so `.zprofile`
is read there. Plain host terminals are non-login shells.

### Host

Layered packages (needs RPM Fusion's NVIDIA driver repo, from GNOME Software's
third-party repositories, and [1Password's repo](https://support.1password.com/install-linux/)):

```
rpm-ostree override remove nano-default-editor --install vim-default-editor
rpm-ostree install 1password akmod-nvidia eza kmod-nvidia langpacks-en_GB \
    lshw open-eid smartmontools sshfs syncthing tailscale vim \
    xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda zsh zsh-autosuggestions \
    zsh-syntax-highlighting
rpm-ostree kargs --append=rd.driver.blacklist=nouveau \
    --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1
```

Flatpaks from Flathub:

```
flatpak install flathub com.github.tchx84.Flatseal com.google.Chrome \
    com.slack.Slack com.spotify.Client com.usebottles.bottles \
    com.valvesoftware.Steam im.riot.Riot io.github.TransmissionRemoteGtk \
    io.github.celluloid_player.Celluloid io.mpv.Mpv net.ankiweb.Anki \
    net.davidotek.pupgui2 net.lutris.Lutris org.signal.Signal org.videolan.VLC
```

### Toolbox

```
toolbox create
toolbox run ~/dotfiles/fedora/toolbox.sh
```

The script is safe to re-run after adding packages to it. On a new Fedora
release, create a fresh toolbox, run the script and `toolbox rm` the old one.

## Machine-local config

- `~/.zshenv` is not tracked: use it for machine-specific environment.
- `~/.gitconfig` takes precedence over the tracked `~/.config/git/config`, e.g.
  for a different email.
- `~/.claude/CLAUDE.md` is local too, since it picks up machine-specific
  instructions. Seed it from the template and update it by hand from there:

  ```
  cp claude/CLAUDE.template.md ~/.claude/CLAUDE.md
  ```

## Poor man's chsh

On some annoying machines it is not possible to use `chsh` to change the login
shell to zsh. Then the following in `.profile.local` may be useful:

```shell
# just run zsh if interactive
[[ $- == *i* ]] && command -v zsh >/dev/null 2>&1 && {
    [ -z "$ZSH_VERSION" ] && export SHELL=$(command -v zsh) && exec $SHELL -l
} || true
```
