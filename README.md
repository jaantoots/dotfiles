# Dotfiles

This is a collection of my dotfiles and scripts. All configurations
are maintained to work on Arch Linux hosts (with occasionally
inelegant solutions for [compatibility with Ubuntu
16.04](setup/ubuntu.md)). Everything should fail gracefully, it is
safe to check out this repository into a new home directory.

## Dunst notifications

Dunst is started automatically as a systemd service through dbus but it is
useful to define an override for the position by `systemctl --user edit
dunst.service`, for example:

```
[Service]
ExecStart=
ExecStart=/usr/bin/dunst -geometry "800x5-0-47"
```

## Browser extensions

Occasionally updated list of used Firefox extensions.

- browserpass-ce
- Facebook Container
- Greasemonkey
- HTTPS Everywhere
- Markdown Here
- Privacy Badger
- Proxy SwitchyOmega
- uBlock Origin
- uMatrix
- Vimium

## Workarounds for Ubuntu workstation (local setup scripts)

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

## License

MIT License

Copyright (c) 2017 Jaan Toots

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
