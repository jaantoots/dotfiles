#!/bin/sh

# set locations
if [ "$(uname)" = "Darwin" ]; then
    xinitdir=/opt/X11/lib/X11/xinit
else
    xinitdir=/etc/X11/xinit
fi
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
xinitrcd=$xinitdir/xinitrc.d

# merge in defaults and keymaps
if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        xrdb -load "$userresources"
    else
        xrdb -nocpp -load "$userresources"
    fi
fi
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d $xinitrcd ] ; then
 for f in $xinitrcd/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# start i3
(which i3 >/dev/null 2>&1) && exec i3

# if the above fails, fall back to defaults
twm &
exec xterm -geometry 80x66+0+0 -name login

