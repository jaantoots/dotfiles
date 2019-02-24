#!/bin/sh

# calculate dynamic variables
xysize="$(xrandr -q | sed -nE -e '/\bconnected\b/H' -e '/\bprimary\b/h' \
    -e '${g;s/(^\n)?[^\n]*\b([0-9]+)x([0-9]+)[^\n]*\b([0-9]+)mm x ([0-9]+)mm.*/\2 \3 \4 \5/p}')"
float_max="$(echo "$xysize" |
    awk 'BEGIN {OFMT="%d"} {print "i3wm.float-max:", $1/2, "x", $2/2;}')"

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
# set dynamic resources for i3
echo "$float_max" | xrdb -merge

# fix dpi
[ -n "${DPI}" ] && xrandr --dpi "${DPI}"
# screenlocker
xset dpms 600 600 600
xset s 590 9
xss-lock -n "$HOME/bin/dim-screen.sh" -- "$HOME/bin/locker" &
# start i3 and ssh-agent
exec ssh-agent i3
