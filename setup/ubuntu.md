# Workarounds for Ubuntu workstation

## Local setup scripts

### `.profile.local`

```shell
# just run zsh if interactive
[[ $- == *i* ]] && hash zsh >/dev/null 2>&1 && {
    [ -z "$ZSH_VERSION" ] && export SHELL=$(which zsh) && exec $SHELL -l
} || true
```

### `.local/bin/urxvt`

```shell
#!/bin/sh

exec /usr/bin/urxvt "$@" -e /bin/zsh
```

### `.xsession`

```shell
#!/bin/sh

userresources=$HOME/.Xresources
localresources=$HOME/.Xresources.local

# merge in defaults and keymaps
if [ -f "$userresources" ]; then
    xrdb -load "$userresources"
fi
if [ -f "$localresources" ]; then
    xrdb -merge "$localresources"
fi

# start i3
exec i3
```

### `.Xresources.local`

```
Xft.dpi: 144
URxvt.letterSpace: 0
```
