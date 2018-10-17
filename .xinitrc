#!/bin/sh

# set locations
userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources
xinitrcd=/etc/X11/xinit/xinitrc.d

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
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

# fix dpi
xrandr --dpi 192
# screenlocker
xset dpms 600 600 600
xset s 590 9
xss-lock -n "$HOME/bin/dim-screen.sh" -- "$HOME/bin/locker" &
# start i3 and ssh-agent
exec ssh-agent i3
