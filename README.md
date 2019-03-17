# Dotfiles

This is a collection of my dotfiles and scripts. All configurations are
maintained to work on Arch Linux hosts. Everything should fail gracefully, it
is probably safe to check out this repository into a new home directory.

## Keyboard configuration

Persistent and sane keyboard configuration with a consistent experience should
be done on the system level.

```
sudo localectl set-x11-keymap us,ee pc105 ,us grp_led:caps,grp:ctrls_toggle,caps:escape,compose:menu,shift:both_shiftlock
```

Typematic delay and rate need to be set as Xserver options, e.g. in
`/etc/X11/xinit/xserverrc`:

```
#!/bin/sh
exec /usr/bin/X -nolisten tcp -ardelay 250 -arinterval 20 "$@"
```

## Dunst notifications

Dunst is started automatically as a systemd service through dbus but it is
useful to define an override for the position by `systemctl --user edit
dunst.service`, for example:

```
[Service]
ExecStart=
ExecStart=/usr/bin/dunst -geometry "800x5-0-47"
```

## Poor man's chsh

On some annoying machines it is not possible to use `chsh` to change the login
shell to zsh. Then the following in `.profile.local` may be useful:

```shell
# just run zsh if interactive
[[ $- == *i* ]] && hash zsh >/dev/null 2>&1 && {
    [ -z "$ZSH_VERSION" ] && export SHELL=$(which zsh) && exec $SHELL -l
} || true
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
