#!/bin/sh

# set locations
if [ "$(uname)" = "Darwin" ]; then
    xinitdir=/opt/X11/lib/X11/xinit
else
    xinitdir=/etc/X11/xinit
fi
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=$xinitdir/.Xresources
sysmodmap=$xinitdir/.Xmodmap
xinitrcd=$xinitdir/xinitrc.d

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    if [ -x /usr/bin/cpp ] ; then
        xrdb -merge $sysresources
    else
        xrdb -nocpp -merge $sysresources
    fi
fi
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi
if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        xrdb -merge "$userresources"
    else
        xrdb -nocpp -merge "$userresources"
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

# fix keyboard
setxkbmap -option ctrl:nocaps

# fix dpi
xrandr --dpi 180

# start i3
(which i3 >/dev/null 2>&1) && exec i3

# if the above fails, fall back to defaults
twm &
exec xterm -geometry 80x66+0+0 -name login

