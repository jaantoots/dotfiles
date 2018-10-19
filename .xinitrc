#!/bin/sh
DPI="$(
{
    { xrandr -q | grep -m 1 '\bprimary\b'; } ||
    { xrandr -q | grep -m 1 '\bconnected\b'; }
} | sed 's/.*\b\([0-9]\+\)x\([0-9]\+\).*\b\([0-9]\+\)mm x \([0-9]\+\)mm.*/\1 \3/' |
    awk 'BEGIN {OFMT="%d"} {print 2/3*(25.4*$1/$2)/48+0.5;}' | awk '{print $1*48;}'
)"

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
    xrdb -merge -DBROWSER="${BROWSER:-firefox}" -DDPI="${DPI:-192}" "$userresources"
fi

# fix dpi
xrandr --dpi "${DPI:-192}"
# screenlocker
xset dpms 600 600 600
xset s 590 9
xss-lock -n "$HOME/bin/dim-screen.sh" -- "$HOME/bin/locker" &
# notifications
dunst -browser ${BROWSER:-firefox} -geometry "800x5-0-47" &
# start i3 and ssh-agent
exec ssh-agent i3
