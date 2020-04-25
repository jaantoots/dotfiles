#!/bin/sh

# set locations
userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources
xinitrcd=/etc/X11/xinit/xinitrc.d

# start some nice programs
if [ -d $xinitrcd ] ; then
 for f in $xinitrcd/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# source variables
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# merge resources
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
if [ -f "$userresources" ]; then
    xrdb -merge "${BROWSER:+-DBROWSER=${BROWSER}}" "${DPI:+-DDPI=${DPI}}" \
        "$userresources"
fi

# fix dpi
[ -n "${DPI}" ] && xrandr --dpi "${DPI}"
# screenlocker
xset dpms 600 600 600
xset s 590 9
xset r rate 250 50
xss-lock -n "$HOME/.dim-screen" -- "$HOME/.locker" &
# start i3
exec i3
