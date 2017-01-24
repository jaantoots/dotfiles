#!/bin/bash
#
# Initialisation script for cloud instances
# Ubuntu 16.04.1 x64

user="thorium"

if [ "$(id -u)" -ne 0 ]; then
    echo "error: please run as root" >&2
    exit 1
fi

read -r -p "warning: proceed? [y/N] " response
case "$response" in
    [yY])
        true
        ;;
    *)
        exit
esac

# Update system and install packages
apt-get -y update
apt-get -y upgrade
apt-get -y install emacs-nox htop zsh

# Set up root environment
chsh -s /bin/zsh
wget -O .zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

# Add new user
useradd -mG sudo $user
chsh -s /bin/zsh $user

# Enable sudo without password
sudof="/etc/sudoers.d/80-sudo-nopasswd"
cat > $sudof <<EOF
# Allow members of group sudo to execute any command without password
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL
EOF
chmod 440 $sudof
visudo -c || exit 1

# Configure user
sudo -u $user wget -O /home/$user/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
sudo -u $user mkdir -m 700 /home/$user/.ssh
cp .ssh/authorized_keys /home/$user/.ssh/
chown $user: /home/$user/.ssh/authorized_keys
sudo -u $user sh -c 'sudo true' || exit 1

# Configure SSH
patch -bz - /etc/ssh/sshd_config <<EOF
28c28
< PermitRootLogin yes
---
> PermitRootLogin no
52c52
< PasswordAuthentication yes
---
> PasswordAuthentication no
EOF
systemctl reload sshd

# Enable ufw
ufw allow OpenSSH
ufw enable
ufw status

echo "done!" >&2
