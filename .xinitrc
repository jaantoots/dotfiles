#!/bin/sh

# set locations
if [ "$(uname)" = "Darwin" ]; then
    xinitdir=/opt/X11/lib/X11/xinit
else
    xinitdir=/etc/X11/xinit
fi
userresources=$HOME/.Xresources
xinitrcd=$xinitdir/xinitrc.d

# merge in defaults and keymaps
if [ -f "$userresources" ]; then
    xrdb -load "$userresources"
fi

# start some nice programs
if [ -d $xinitrcd ] ; then
 for f in $xinitrcd/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# start i3
(which i3 >/dev/null 2>&1) && exec i3
