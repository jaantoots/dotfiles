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
    xrdb -merge "$userresources"
fi

# fix dpi
[ -n "${DPI}" ] && xrandr --dpi "${DPI}"
[ -n "${DPI}" ] && echo "*dpi: ${DPI}" | xrdb -merge
# screenlocker
xset dpms ${_XSET_DPMS:-600} ${_XSET_DPMS:-600} ${_XSET_DPMS:-600}
xset s ${_XSET_S:-590 9}
xset r rate 250 50
# start i3
exec i3
