# Arch Linux setup

Notes for installing and configuring Arch Linux.

Using `etckeeper` is a great idea but missing from the following. I
suppose there always has to be room for improvement.

## Installation

Boot from live image. All commands as `root@archiso ~ #`.

```shell
timedatectl set-ntp true
```

Check disks and SSD TRIM capabilities (for reference):

```shell
fdisk -l
hdparm -I /dev/sda | grep "TRIM"
```

Fill SSD with random data to hide usage patterns (use `dm-crypt` to
match future patterns and for speed):

```shell
cryptsetup open --type plain /dev/sda container --key-file /dev/random
dd if=/dev/zero of=/dev/mapper/container status=progress
cryptsetup close container
```

Create GPT partition table and partitions:

```shell
gdisk /dev/sda
```

- `1`: 256M EFI System (`/boot`)
- `2`: Linux filesystem (`/`)

EFI System Partition (ESP) must be formatted as FAT32:

```shell
mkfs.fat -F32 /dev/sda1
```

Set up encrypted root partition with default parameters:

```shell
cryptsetup -v -y luksFormat /dev/sda2
cryptsetup open --allow-discards /dev/sda2 cryptroot
mkfs -t ext4 /dev/mapper/cryptroot
mount -t ext4 /dev/mapper/cryptroot /mnt
```

Mount the ESP as `/boot`:

```shell
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

Install the base packages:

```shell
pacstrap /mnt base
```

Generate `fstab` file:

```shell
genfstab -U /mnt >> /mnt/etc/fstab
```

Change root into new system:

```shell
arch-chroot /mnt
```

Set clock:

```shell
ln -s /usr/share/zoneinfo/Cydonia/Mensae /etc/localtime
hwclock --systohc --utc
```

Uncomment `en_US.UTF-8 UTF-8` (and other needed localizations) in
`/etc/locale.gen`, and set the `LANG` variable in `locale.conf(5)`
accordingly:

```shell
patch -b /etc/locale.gen <<EOF
168c168
< #en_US.UTF-8 UTF-8
---
> en_US.UTF-8 UTF-8
EOF
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

Create `/etc/hostname` with the desired hostname, and add a matching
line to `/etc/hosts`:

```shell
echo foo > /etc/hostname
patch -b /etc/hosts <<EOF
7a8
> 127.0.1.1    foo.localdomain foo
EOF
```

Add the `encrypt` hook to `mkinitcpio.conf`:

```shell
patch -b /etc/mkinitcpio.conf <<EOF
52c52
< HOOKS="base udev autodetect modconf block filesystems keyboard fsck"
---
> HOOKS="base udev autodetect modconf block encrypt filesystems keyboard fsck"
EOF
```

Create new `initramfs`:

```shell
mkinitcpio -p linux
```

Set root password:

```shell
passwd
```

Check access to EFI variables (and optionally check the boot
configuration):

```shell
pacman -S efivar
efivar -l
pacman -S efibootmgr
efibootmgr -v
```

Install `systemd-boot` and edit the configuration:

```shell
bootctl --path=/boot install
```

Install `intel-ucode`:

```shell
pacman -S intel-ucode
```

Get the UUID of the disk (using `blkid` or `ls -l /dev/disk/by-uuid`),
add `default arch-*` to `loader.conf`, and add the entry, enabling
microcode updates and TRIM for the SSD:

```shell
cat > /boot/loader/loader.conf <<EOF
#timeout 3
default arch-*
EOF
cat > /boot/loader/entries/arch-encrypted.conf <<EOF
title   Arch Linux Encrypted
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options cryptdevice=UUID=<UUID>:root:allow-discards root=/dev/mapper/root rw
EOF
```

*Hardware specific*: To fix an issue with the wireless hardware, add
disable the `b43` drivers (use `brcmsmac`):

```shell
cat > /etc/modprobe.d/brcm.conf <<EOF
# Do not load b43 on boot
blacklist b43
blacklist b43legacy
EOF
```

Finally, exit and reboot into the new system:

```shell
exit
reboot
```

## Configuration

Now as `root@foo ~ #`.

Start and enable DHCP on wired interface (use `ip addr` to get device
handle):

```shell
systemctl start dhcpcd@enp1s0.service
systemctl enable dhcpcd@enp1s0.service
```

Update all packages and install SSH:

```shell
pacman -Syu openssh
```

Configure `logind`:

```shell
patch -b /etc/systemd/logind.conf <<EOF
17c17
< #KillUserProcesses=no
---
> KillUserProcesses=no
21c21
< #HandlePowerKey=poweroff
---
> HandlePowerKey=ignore
EOF
systemctl restart systemd-logind
```

Install other packages:

```shell
pacman -Syu hdparm htop mlocate
updatedb
pacman -Syu emacs-nox zsh zsh-completions grml-zsh-config
```

Change root shell to `zsh` (and change to it):

```shell
chsh -s /bin/zsh
```

Create regular users, install `sudo`, and configure `sudoers`:

```shell
groupadd -r sudo
groupadd -r ssh
useradd -m -G sudo,ssh jaan
passwd jaan
pacman -Syu sudo
EDITOR=emacs visudo
# %wheel ALL=(ALL) NOPASSWD: ALL
# %sudo ALL=(ALL) ALL
```

Add a key to the new user and then lock down SSH:

```
patch -b /etc/ssh/sshd_config <<EOF
43c43
< #PermitRootLogin no
---
> PermitRootLogin no
71c71
< #PasswordAuthentication yes
---
> PasswordAuthentication no
132a133,134
>
> AllowGroups ssh
EOF
```

Set up a simple firewall (add other services as necessary):

```shell
pacman -Syu ufw
ufw default deny
ufw allow from 192.168.0.0/16
ufw allow SSH
ufw limit SSH
ufw enable
systemctl enable ufw
systemctl start ufw
```

Synchronise time:

```shell
pacman -Syu ntp
systemctl enable ntpd
systemctl start ntpd
```

Monitor network usage:

```shell
pacman -Syu vnstat
systemctl enable vnstat
systemctl start vnstat
```

Some useful tools for managing filesystems (including Apple HFS+):

```shell
pacman -Syu gdisk hfsprogs
```

Install development tools and set up `devel` user:

```shell
pacman -Syu --needed base-devel git
useradd -m -G wheel devel
```

## Set up remote unlocking

Switch to the new user (`sudo -u devel -i`) and install packages for
SSH access in early userspace (`devel@foo ~ %`):

```shell
sudo pacman -Syu dropbear
mkdir builds
mkdir build-repos
cd build-repos
git clone https://aur.archlinux.org/mkinitcpio-utils.git
cd mkinitcpio-utils && makepkg -sri && cd ..
git clone https://aur.archlinux.org/mkinitcpio-netconf.git
cd mkinitcpio-netconf && makepkg -sri && cd ..
git clone https://aur.archlinux.org/mkinitcpio-dropbear.git
cd mkinitcpio-dropbear && makepkg -sri && cd ..
exit
```

Add authorized key to `dropbear`, patch `mkinitcpio.conf`, update the
bootloader to use DHCP to configure the network interface, and rebuild
initramfs (`root@foo ~ #`):

```shell
cat /root/.ssh/authorized_keys > /etc/dropbear/root_key
patch -b /etc/mkinitcpio.conf <<EOF
52c52
< HOOKS="base udev autodetect modconf block encrypt filesystems keyboard fsck"
---
> HOOKS="base udev autodetect modconf block netconf dropbear encryptssh filesystems keyboard fsck"
EOF
patch -b /boot/loader/entries/arch-encrypted.conf <<EOF
5c5
< options cryptdevice=UUID=<UUID:root:allow-discards root=/dev/mapper/root rw
---
> options ip=:::::eth0:dhcp cryptdevice=UUID=<UUID>:root:allow-discards root=/dev/mapper/root rw
EOF
mkinitcpio -p linux
```

Reboot to test and enter disk encryption passphrase over SSH:

```shell
reboot
ssh root@foo
```

## Dynamic DNS

As root, since the script is private and should not be run by other
users (`root@foo ~ #`):

```shell
mkdir bin
# Download/link the script into bin
cat > /etc/systemd/system/dynamic-dns-client.service <<EOF
[Unit]
Description=Update Dynamic DNS for foo

[Service]
Type=oneshot
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
ExecStart=/root/bin/script.sh
EOF
cat > /etc/systemd/system/dynamic-dns-client.timer <<EOF
[Unit]
Description=Run dynamic-dns-client every 5 minutes

[Timer]
OnBootSec=30s
OnUnitActiveSec=5m

[Install]
WantedBy=timers.target
EOF
systemctl start dynamic-dns-client.timer
systemctl enable dynamic-dns-client.timer
```

Add a hostname entry to local router and update `/etc/hosts`:

```shell
patch -b /etc/hosts <<EOF
8c8
< 127.0.1.1    foo.localdomain foo
---
> 127.0.1.1    foo.example.com foo
EOF
```

## Display environment

Install Xorg (display server, launcher, database reader & xterm),
pulseaudio and i3 (window manager, dmenu & feh image viewer):

```shell
pacman -Syu xorg-server xorg-xinit xorg-xrdb xterm
pacman -Syu pulseaudio pulseaudio-alsa alsa-utils
pacman -Syu i3 dmenu feh
```

Pulseaudio installs `polkit` but the power management should be
disabled:

```shell
cat > /etc/polkit-1/rules.d/10-disable-power.rules <<EOF
/* -*- mode: js; js-indent-level: 4; indent-tabs-mode: nil -*- */

polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.suspend" ||
        action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
        action.id == "org.freedesktop.login1.hibernate" ||
        action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
    {
        return polkit.Result.NO;
    }
    if (action.id == "org.freedesktop.login1.power-off" ||
        action.id == "org.freedesktop.login1.reboot")
    {
        return polkit.Result.NO;
    }
});
EOF
```

Unmute audio:

```shell
alsamixer
```

*Hardware specific*: Fiddle with the pulseaudio configuration:

```shell
patch -b /etc/pulse/default.pa <<EOF
38c38
< #load-module module-alsa-sink
---
> load-module module-alsa-sink device=hw:0,7
139c139
< #set-default-sink output
---
> set-default-sink 0
EOF
```

Install some more fonts:

```shell
pacman -Syu ttf-dejavu ttf-inconsolata ttf-droid
```

Install urxvt (with modifications) and i3lock-blur:

```shell
sudo -u devel -i
cd build-repos
git clone https://aur.archlinux.org/rxvt-unicode-fontspacing-noinc-vteclear-secondarywheel.git
cd rxvt-unicode-fontspacing-noinc-vteclear-secondarywheel && makepkg -sri && cd ..
git clone https://aur.archlinux.org/i3lock-blur.git
cd i3lock-blur && makepkg -sri && cd ..
exit
```

Enable pulseaudio socket for user:

```shell
systemctl --user enable pulseaudio.socket
systemctl --user start pulseaudio.socket
```

## Transmission

Install and start Transmission, edit the configuration (and set umask
to 2), load configuration and add required users to the `transmission`
group:

```shell
pacman -Syu transmission-cli
systemctl enable transmission
systemctl start transmission
emacs /var/lib/transmission/.config/transmission-daemon/settings.json
pkill -HUP transmission
chmod 770 /var/lib/transmission
usermod -a -G transmission jaan
```

Define UFW rules for Transmission:

```shell
cat > /etc/ufw/applications.d/custom <<EOF
[Transmission-PORT]
title=Transmission
description=Transmission BitTorrent client
ports=PORT/tcp

[Transmission-RPC]
title=Transmission-RPC
description=Transmission RPC
ports=9091/tcp
EOF
ufw allow Transmission-PORT
```

## User configuration

Generate SSH key and clone `dotfiles` repository (finally `jaan@foo ~ %`):

```shell
ssh-keygen -t ed25519
git init
git remote add origin git@github.com:jaantoots/dotfiles.git
git fetch
git checkout master
```

(Optional) Install Node.js and a package to apply styles to i3
(e.g. `i3-style solarized -o ~/.i3/config --reload`):

```shell
sudo pacman -Syu nodejs npm
sudo npm install -g i3-style
```

Celebrate the successful installation by taking a screenfetch:

```shell
sudo pacman -Syu screenfetch scrot
screenfetch -s
```
